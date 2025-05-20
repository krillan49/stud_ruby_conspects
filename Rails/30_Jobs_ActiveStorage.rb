puts '                                      Jobs. Импорт ZIP в background'

# В админском контроллере admin/users_controller.rb мы загружали и выгружали пользователей в формате EXEL, а эти операции могут занимать много времени, поэтому лучше перенести их выполнение в бэкграунд (при помощи Sidekiq)

# 1. Откроем дирректорию app/jobs в которой уже еть главный джоб/задача application_job.rb от которого и будут наследовать остальные наши задачи
# Создадим новый джоб app/jobs/user_bulk_import_job.rb (имя любое), в котором будем делать импорт EXEL фаилов для закгрузки ZIP-фзхива с xlsx фаилами админом ы систему
class UserBulkImportJob < ApplicationJob # наследует от главного джоба
  queue_as :default # обязательно указываем в какую очередь будет помещена задача(у нас очередь default)

  def perform() # обязательно должен быть этот метод с таким названием, который и будет описывать задачу которую мы будем выполнять в бэкграунде
  end
end

# 2. В контроллере admin/users_controller.rb вызовем эту задачу в методе create
module Admin
  class UsersController < BaseController
    # ...
    def create
      if params[:archive].present?
        # UserBulkService.call params[:archive] - раньше так вызывали сервисный объект services/user_bulk_service.rb, теперь будем вызывать задачу, а секрвис будет вызван уже в задаче:
        UserBulkImportJob.perform_later() # но мы не можем просто сюда как параметр передать params[:archive] или даже params[:archive].path потому что это временный фаил, существующий только в памяти и когда задача начнет выполняться его может уже не быть
        # perform_later - (?? генерится от метода perform UserBulkImportJob) поставит задачу в очередь и сделает ее в фоне (в отличие от простого perform)
        flash[:success] = t '.success'
      end
      redirect_to admin_users_path
    end
    # ...
  end
end



puts '                                  ActiveStorage. Импорт ZIP в background'

# Так как мы не сможем нормально воспользоваться загруженным архивом из params[:archive] для передачи его в метод perform_later джоба user_bulk_import_job.rb, тк это временный архив и может уже удалиться до момента передачи. Нам нужно сделать этот архив не временным, тоесть нам нужно его где-то сохранить, на время его обработки, не во временной папке, а где-то в постоянном хранилище.

# Можно использовать облачные(например Амазон) и локальные хранилища, можно написать собственный скрипт, который берет этот архив и помещает в другую папку, но проще задействовать ActiveStorage.

# ActiveStorage - функционал Рэилс, который предоставляет интерфейс, через который можно сохранять фаилы в разные хранилища, как в облачные(тот же Амазон), так и в локальные. Он предоставляет общий интерфейс, который мы настраиваем, определяя куда нужно сохранять.


# Конфигурация для интерфейса ActiveStorage есть по умолчанию в фаиле config/storage.yml (код и описание там)
# А какой будет использоваться бэкэнд для сохраниеия фаилов прописано уже в config/environments/development.rb и config/environments/production.rb

# Для того чтобы настроить интерфейс ActiveStorage, нужно запустить команду:
# > rails active_storage:install
# Это создаст специальные миграции и таблицы в нашей БД, чтобы хранить информацию о тех фаилах что мы будем сохранять через AS (их код если надо можно посмотреть в db/migrate/20240207132406_create_active_storage_tables.active_storage)
# > rails db:migrate         -  естественно их нужно применить


# Теперь мы можем сохранить временный архив из params[:archive] себе локально в директорию storage, чтобы потом с этим архивом работать в ActiveJob


# 1. В контроллере admin/users_controller.rb создадим новый приватный метод create_blob (название любое), который создаст новый фаил в ActiveStorage
module Admin
  class UsersController < BaseController
    # ...

    def create
      if params[:archive].present?
        # Отправляем задачу импорта фаила в наш джоб
        UserBulkImportJob.perform_later create_blob, current_user
        # create_blob  - наш метод(айди загруженного фаила)
        # current_user - текущий юзер, чтобы например на его имэйл послать письмо с подтверждением выполнения задачи
        flash[:success] = t '.success'
      end
      redirect_to admin_users_path
    end

    # ...

    private

    def create_blob # создаст на основе временного фаила новый фаил в ActiveStorage и вернет его ключ.
      file = File.open params[:archive] # открываем фаил временного архива, загруженный админом
      result = ActiveStorage::Blob.create_and_upload! io: file, filename: params[:archive].original_filename
      # ActiveStorage::Blob.create_and_upload!       - создает и закружает фаил из временных данных
      # io: file                                     - параметр в который передаем наш открытый фаил
      # filename: params[:archive].original_filename - именем фаила берем имя загруженного архива
      file.close
      result.key # key - вернет уникальный идентификатор загруженного фаила. Он будет храниться в БД, в одной из таблиц ActiveStorage
    end

    # ...
  end
end


# 2. app/services/user_bulk_import_service.rb - переназовем так сервисный объект user_bulk_service.rb(Admin_Exel_Zip) тк он занимается только импортом(код там). Далее модифицируем его тк будем использовать его в джобе user_bulk_import_job.rb


# 3. В джобе app/jobs/user_bulk_import_job.rb в методе perform вызванным из контроллера, запустим медоды из user_bulk_import_service.rb
class UserBulkImportJob < ApplicationJob
  queue_as :default

  def perform(archive_key, initiator) # из perform_later из контроллера принимаем ключ загруженного архива и юзера его загрузившего
    UserBulkImportService.call archive_key # передаем ключ архива в метод сервиса call
    # Далее пошлем админу письмо, что задача успешно завершена(ну или нет)
  rescue StandardError => e
    # если будет ошибка то обработаем ее и отправим письмо с сообщением что есть ошибка
    Admin::UserMailer.with(user: initiator, error: e).bulk_import_fail.deliver_now
  else
    Admin::UserMailer.with(user: initiator).bulk_import_done.deliver_now
    # user: initiator  - передавем в мэйлер admin/user_mailer.rb пользователя, которому отправляем
    # bulk_import_done - метод мэйлера admin/user_mailer.rb
    # deliver_now      - тут именно доставить сейчас а не deliver_later, так мы тут и так уже находимся в бэкграунде
  end
end


# 4. Для писем из пункта 3:
# a. в мэйлерах создадим директорию админа и в ней мэйлер admin/user_mailer.rb (код там)
# б. в представлениях админа создадим новую директорию admin/user_mailer и представления для писем в ней для каждого формата письма и языка отдельное, с базовыми названиями, соответсвующими названиям методов мэйлера bulk_export_done, bulk_import_fail


# Теперь мы можем загружать архив в приложение(например с несколькими xlsx фаилами, где в каждом по несколько пользователей и каким-то левым, например txt-фаилом, для проверки что будет обработывать только нужный формат)

# В консоли Сайдкика после удачной загрузки можно найти строку, после записи о джобе:
# Disk Storage (0.8ms) Deleted file from key: zqy8316bfdugbscu29atj4ufbon5
# Она говорит о том что фаил ActiveStorage после обработкт джоба удален по ключу



puts '                                  ActiveStorage. Экспорт ZIP в background'

# Загрузим архив со списком пользователей из приложения, но не синхронно(тк эта задача тоже может занять время), а в бэкграунде и чтобы после завершения задачи, не сразу выдавалось меню скачивания, а ссылка на архив была прислана на почту


# 1. Создадим новый сервисный объект для экспорта services/user_bulk_export_service.rb (код там)


# 2. Создадим отдельный джоб для экспорта jobs/user_bulk_export_job.rb (код там)


# 3. В контроллере admin/users_controller.rb запустим джоб экспорта, который использует сервис экспорта и отправит письмо со ссылкой на скачивание списка пользователей
module Admin
  class UsersController < BaseController
    # ...
    def index
      respond_to do |format|
        format.html do
          @pagy, @users = pagy User.order(created_at: :desc)
        end

        # format.zip { respond_with_zipped_users } - раньше тут вызывался метод respond_with_zipped_users, удаляем это, удаляем сам метод который был тут же в private и переносим функционал из него в user_bulk_export_service.rb
        format.zip do
          UserBulkExportJob.perform_later current_user # вызываем джоб экспорта и передаем ему активного пользователя
          flash[:success] = t '.success' # тут можно сообщить что ссылка на скачивание придет на почту
          redirect_to admin_users_path
        end
      end
    end
    # ...
  end
end



puts '                                  ActiveStorage. Вывод в представления'

# В Ruby on Rails, если вы используете ActiveStorage для загрузки файлов, данные о файлах связаны с сущностями через ассоциации. Чтобы получить картинки (или другие файлы), связанные с моделью, вам нужно использовать методы, предоставленные ActiveStorage.

# Предположим, у вас есть модель `User`, которая имеет загруженное изображение профиля через ActiveStorage. Вот как это может выглядеть:
class User < ApplicationRecord
  has_one_attached :profile_picture
end

# Чтобы вызвать данные этого изображения в вашем представлении (View), можно сделать следующее:
# 1. **Проверка наличия файла**: Сначала убедитесь, что файл загружен.
# 2. **Отображение изображения**: Используйте хелпер `image_tag`, чтобы отобразить изображение на странице.

# Пример представления (например, в `app/views/users/show.html.erb`):
# <% if @user.profile_picture.attached? %>
#   <%= image_tag @user.profile_picture %>
# <% else %>
#   <p>No profile picture available.</p>
# <% end %>

# Еще методы проверки
@user.profile_picture.any?
@user.profile_picture.present?


### Пример использования других типов файлов

# Если вы загружаете другие типы файлов, например, документы, и хотите предоставить ссылку на их загрузку, вы можете сделать следующее:
# <% if @user.resume.attached? %>
#   <%= link_to 'Download Resume', rails_blob_path(@user.resume, disposition: 'attachment') %>
# <% else %>
#   <p>No resume available.</p>
# <% end %>


### Подсоску на другие варианты

# Кроме того, можно использовать различные опции для указания формата и размера изображений, если это необходимо, например, используя `variant` для обработки изображений:
# <% if @user.profile_picture.attached? %>
#   <%= image_tag @user.profile_picture.variant(resize: "100x100") %>
# <% end %>


# Таким образом, вы можете легко извлекать и отображать загруженные файлы в ваших представлениях



puts '                                  добавления данных в Active Storage'

# Для добавления данных в Active Storage в Rails, вам нужно следовать нескольким шагам. Active Storage позволяет загружать файлы и хранить их вне вашего приложения, например, в облаке (Amazon S3, Google Cloud Storage и т.д.) или на локальном диске.

# Вот общий подход для добавления данных в Active Storage:

### 1. Настройка Active Storage

# Если вы еще не настроили Active Storage, выполните команду:

# $ rails active_storage:install


# Это создаст миграции для создания таблиц, необходимых для работы с Active Storage. После этого выполните миграции:

# $ rails db:migrate


### 2. Добавление ассоциаций в модель

# В модели, для которой вы хотите добавить функциональность загрузки файлов, добавьте соответствующую ассоциацию. Например, если вы хотите связать изображение с моделью `User`, это может выглядеть так:

class User < ApplicationRecord
  has_one_attached :avatar
end


### 3. Загрузка файлов через форму

# Создайте или обновите форму, чтобы позволить пользователям загружать файлы. Например:

# <%= form_with model: @user, local: true do |form| %>
#   <%= form.label :avatar %>
#   <%= form.file_field :avatar %>
#   <%= form.submit %>
# <% end %>


### 4. Обработка данных в контроллере

# В контроллере создайте или обновите действие, чтобы сохранять загруженные файлы. Например:

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end
end


### 5. Отображение загруженного файла

# Чтобы отобразить загруженный файл, например, изображение, вы можете сделать это в представлении:

# <% if @user.avatar.attached? %>
#   <%= image_tag @user.avatar %>
# <% end %>


### 6. Дополнительные настройки

# Не забудьте настроить файлы конфигурации, если вы используете сторонние сервисы для хранения, например, S3. Это делается в файле `config/storage.yml`.

### Примечания

# - Убедитесь, что вы добавили необходимые гемы в Gemfile (например, `gem 'aws-sdk-s3'` для работы с S3).
# - Также важно использовать проверки валидации на уровне модели, чтобы ограничить типы и размеры загружаемых файлов.
















#
