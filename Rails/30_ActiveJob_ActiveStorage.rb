puts '                                            ActiveJob'

# Некоторые задачи выполняются долго и если мы выполняем их синхронно, то у пользователя в браузере произойдет таймаут, а если задача выполняется слишком долго браузер прервет выполнение и выдаст ошибку из-за того что страница грузится слишком долго

# ActiveJob - это функционал встроенный в Рэилс, который позволяет отправлять задачи различным адаптерам(kafka, sidekiq), которые будут выполнять эти задачи в фоновом режиме, те будут управлять очередями, задачами итд. Пользователь не ждет пока задача будет выполнена, а может дальше что-то делать и в приложении и ничего не подвиснет, тк задача будет выполняться в бэкграунде.

# В Рэилс нет адаптеров по умолчанию, поэтому нужно специальное решение, которое будет правильным образом выполнять обработку, ставить задачи в очередь, при необходимости выполнять задачи снова, если возникла ошибка итд

# Есть разные движки/адаптеры которые могут выполнять задачи в бэкграунде, например:
# kafka   - более сложное решение
# sidekiq - более простое(но тоже большое) решение



puts '                                             Sidekiq'

# https://github.com/sidekiq/sidekiq
# https://github.com/sidekiq/sidekiq/wiki/Getting-Started

# sidekiq - позволяет создавать задачи в фоновом режиме как для Рэилс(через ActiveJob - есть раздел в описании сайдкика), так и без него. (есть как бесплатная так и энтерпрайз версии)


# 1. Установка:

# Gemfile:
gem 'sidekiq', '~> 7'
# > bundle i

# Для работы sidekiq необходим Redis - NO-SQL БД, которую sidekiq использует для храниения информации о задачах.

# https://redis.io/download/   -  На *nix-системах просто устанавливаем с офф сайта

# Но на виндоус redis новых версий больше не поддерживается, так что нужно использовать альтернативное решение Memurai, которое полностью повторяет API Редиса
# https://www.memurai.com/get-memurai - бесплатно скачать можно только Developer Edition, тоесть в продакшн нормально поддерживать не получится и нужно рестартить каждые 10 дней (имеется ввиду сервер рестарт ??), полноценная версия платная
# https://docs.memurai.com/en/installation.html  -  как установить

# (?? В доках sidekiq еще описана замена Dragonfly, мб она тоже поддерживается ??).

# После того как мы установили redis/memurai, Сайдкик по умолчанию к нему подключится
# localhost:6379  - порт локалхоста по которому будет работать Редис по умолчанию
# https://github.com/sidekiq/sidekiq/wiki/Using-Redis   - описание как подключтиться по другому порту и еще всякое


# 2. Настройка:

# Создадим конфигурацию для Сайдкика config/sidekiq.yml (код там)

# Далее нужно явно сказать Рэилс, какой адаптер будет использоваться ActiveJob-ом
# https://github.com/sidekiq/sidekiq/wiki/Active-Job - копируем отсюда строку и помещаем в config/application.rb:
class Application < Rails::Application
  # ...
  config.active_job.queue_adapter = :sidekiq
end


# 3. Запуск:

# Запускать sidekiq нужно в отдельном окне командной строки в директории проекта, тк sidekiq запускает как бы свой сервер и идет свой отладочный вывод
# > bundle exec sidekiq -q default

# Так же если нужно можно запускать sidekiq одновременно с сервером Рэилс (соответсвенно и вывод будет и для Рэилс и для Сайдкик в одной консоли) - для этого добавим строку с воркером в Procfile.dev (в нем располагаются инструкции запуска через bin/dev):
# worker: bundle exec sidekiq -q default



puts '                                Sidekiq для отправки письма сброса пароля'

# Письма можно отправлять в бэкграунде, в фоновом режиме, например при помощи метода deliver_later, как мы делали в контроллере PasswordResetsController (malers).

# Проверим будет ли приходить письмо с настройками сброса пароля (mailers) в фоновом режиме:
PasswordResetMailer.with(user: @user).reset_email.deliver_later
# Когда в password_resets_controller.rb используем метод deliver_later и если есть адаптер для выполнения задач в фоновом режиме, тогда эта задача будет передана адаптеру и задача будет выполнена в бэкграунде

# Когда сервер Рэилс отправляет письмо, отладочный вывод Сайдкика показывает, что использует ActionMailer, задачу с ее айди, адаптер, мэйлер, метод мэйлера и метод задачи и параметры:
# INFO: Performing ActionMailer::MailDeliveryJob (Job ID: 3d08abae-0c6f-4635-8239-f979ca856b2e) from Sidekiq(default) enqueued at 2024-02-04T12:57:51Z with arguments: "PasswordResetMailer", "reset_email", "deliver_now", {:params=>{:user=>#<GlobalID:0x000002a28cffa7e0 @uri=#<URI::GID gid://ask-it/User/7>>}, :args=>[]}

# А в консоли Рэилс будет:
# [ActiveJob] Enqueued ActionMailer::MailDeliveryJob (Job ID: 3d08abae-0c6f-4635-8239-f979ca856b2e) to Sidekiq(default) with arguments: "PasswordResetMailer", "reset_email", "deliver_now", {:params=>{:user=>#<GlobalID:0x000001dd77e2d4b0 @uri=#<URI::GID gid://ask-it/User/7>>}, :args=>[]}

# Это говорит о том что сервер поставил в очередь задачу на выполнение и эта задача будет выполняться в фоновом режиме



puts '                    Визуальный интерфейс для отслеживания задач. Констрейт для маршрутов'

# В routes.rb настроим маршрут для интерфейса отслеживания задач в нашем приложении, так же ограничим его только для администратора

# (Весь код далее из routes.rb)

require 'sidekiq/web' # подключаем сайдкик-веб

# Для того чтобы ограничить интерфейс только для администратора, добавим констрэйт(класс ограничения)
class AdminConstraint
  def matches?(request) # обязательно должен быть этот метод
    # request - это тот запрос, который был отправлен на маршрут (тут '/sidekiq'), он перенаправляется сюда на проверку(тк тело запроса содержит данные о сессии и куки), чтобы мы поняли от кого пришел запрос
    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id] # возьмем user_id либо из сессии, либо из зашифрованного куки если пользователь поставил галочку запомнить его
    # request.session[:user_id] - находим в теле запрса данные сессии и в них айди пользователя
    # request.cookie_jar.encrypted[:user_id] - находим в теле запрса зашифрованный куки, но просто обратиться к нему не получится, поэтому нужно дополнительно применить метод cookie_jar
    # cookie_jar - берется из модуля (?)АктивДиспатч, этот модуль доступен в маршрутах потому дешифровка куки будет автоматической
    User.find_by(id: user_id)&.admin_role? # ищем пользователя по айди и проверяем админ ли это
    # Либо пускаем этого пользователя по этому маршруту либо нет, в зависимости от того что вернет метод.
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  # mount - метод монтирует маршрут на основе параметров
  # Sidekiq::Web => '/sidekiq'  - выбираем адрес по которому в приложении будет доступен Sidekiq::Web, тоесть мы подключаем интерфейс Сайдкика по данному адресу на нашем сайте.
  # constraints: AdminConstraint.new - опция для обращения к проверке констрэйтом, чтобы разрешить этот маршрут только админу

  # ...
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    # ...
    namespace :admin, constraints: AdminConstraint.new do
      # constraints: AdminConstraint.new - можно использовать тот же ограничитель, чтоб дополнительно ограничить пространсво имен маршрутов админа
      resources :users, only: %i[index create edit update destroy]
    end
    # ...
  end
end

# Далее открываем приложение по адресу 'http://localhost:3000/sidekiq' и видем подробную статистику по задачам и действиями с ними со всякими менюшками и графиками



puts '                                      Jobs. Импорт ZIP в background'

# В админском контроллере admin/users_controller.rb мы загружали и выгружали пользователей в формате EXEL, а эти операции могут занимать много времени, поэтому лучше перенести их выполнение в бэкграунд

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
        # UserBulkService.call params[:archive] - раньше так вызывали сервисный объект services/user_bulk_service.rb, теперь будем вызывать задачу:
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

# Так как мы не сможем нормально воспользоваться загруженным архивом из params[:archive] для передачи его в метод perform_later джоба user_bulk_import_job.rb, тк это временный архив и может уже удалиться до момента передачи. Нам нужно сделать этот архив не временным, тоесть нам нужно его гдето сохранить, на время его обработки, не во временной папке, а гдето в постоянном хранилище.

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
    # user: initiator - передавем в мэйлер admin/user_mailer.rb пользователя, которому отправляем
    # bulk_import_done - метод мэйлера admin/user_mailer.rb
    # deliver_now - тут именно доставить сейчас а не deliver_later, так мы тут и так уже находимся в бэкграунде
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


















#
