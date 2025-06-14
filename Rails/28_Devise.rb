puts '                                              Devise'

# Devise - гем для регистрации, аутонтификации и авторизации

# Главный секретный ключ(нужен чтобы устанавливать куки для пользователей) config.secret_key =(изначально закоменчен) находится /config/initializers/devise.rb

# !!! Много ошибок решается перезагрузкой сервера Рэилс

# https://github.com/heartcombo/devise
# https://github.com/plataformatec/devise                              -  Документация по гему devise
# https://habr.com/ru/post/208056/                                     -  Статья на Хабре по devise
# https://github.com/plataformatec/devise/wiki/Example-applications    -  Посмотреть примеры как используется
# https://github.com/heartcombo/devise#controller-filters-and-helpers  -  Хэлперы девайс

# Инфа от установщика по донастройке:
# https://github.com/heartcombo/devise/blob/main/CHANGELOG.md
# https://github.com/heartcombo/devise/wiki/How-To:-Upgrade-to-Devise-4.9.0-%5BHotwire-Turbo-integration%5D



puts '                                 Установка в Рэилс-приложение и настройка'

# 1. Gemfile:
gem 'devise'
# > bundle

# Добавились devise-опции в разные разделы

# Появился генератор Devise с 4мя опциями(генераторами):
# > rails g
# Devise:
#   devise
#   devise:controllers
#   devise:install
#   devise:views



# 2. Установим Devise в приложение:
# > rails g devise:install
# Создались config/initializers/devise.rb  и  config/locales/devise.en.yml.
# Так же вывелись подсказки по донастройкам, воспользуемся ими:

#     2-1. config/environments/development.rb  - добавим строку(если ее нет):
Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # добавим строку
end

#     2-2. /config/routes.rb  - проверить, что указан правельный корень(добавить если нет):
root to: "home#index"

#     2-3. app/views/layouts/application.html.erb - добавить(если нет) в Лэйаут элементы для отображения флеш-сообщений:
# <p class="notice"><%= notice %></p>
# <p class="alert"><%= alert %></p>

#     2-4. По умолчанию во views представлений для devise нет, поэтому, если нужно отредактировать представления devise либо сделать свои шаблоны для форм(логина, пароля итд), то можно сгенерировать набор views что использует devise по умолчанию:
# > rails g devise:views                    - сгенерирует директории и представления во views в директории devise


# 3. Другое:
# > rails generate devise:controllers users    - генерация devise-контроллеров, если нужно что-то в них изменить


# !!! После добавления и настройки Devise необходимо перезапустить приложение, иначе возникнут ошибки



puts '                                Создание devise-модели и миграции'

# Создадим модель пользователя, но при помощи генератора devise вместо model, так модель сразу создастся со всеми необходимыми свойствами для авторизации: e-mail, зашифрованный пароль, токен для сброса пароля, необходимые индексы для таблиц итд итп:

# > rails g devise User

# Создалась миграция db/migrate/20230721073907_devise_create_users.rb
class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token   # токен для сброса пароля
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # ... Так же много еще закоментированных разделов которые тут удалил чтоб не занимало место ...

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end

# app/models/user.rb  - создалась модель с опциями: регистрация, восстановление пароля итд итп
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
end

# > rake db:migrate


# !! В Rails 7 может быть ошибка при регистрации: Undefined method 'user_url'
# Нужно в config/initializers/devise.rb добавить/раскомментировать:
config.navigational_formats = ['*/*', :html, :turbo_stream]


# 2. Добавим ссылки входа и выхода в лэйаут /app/views/layouts/application.html.erb

# ?? Альтернатива тому чтобы добавлять 'turbo' в ссылки ??
# Ссылка выхода по умолчанию не работала(?? по умочанию POST а нужен GET ??), необходимо в route.rb:
devise_for :users # после этой строки...
# ... написать еще маршрут(юзер в единственном числе):
devise_scope :user do
  get '/users/sign_out' => 'devise/sessions#destroy'
end
# + В config/initializers/devise.rb изменить значение config.sign_out_via
config.sign_out_via = :delete # было это
config.sign_out_via = :get    # изменить на это



puts '                                     Фильтр authenticate_user!'

# authenticate_user! - встроенный метод-фильтр devise, делает экшены контроллера недоступными неавторизованному юзеру и при запрсах будет перенаправлять на форму авторизации devise. Нужно через before_action вызвать в контроллере authenticate_user!.

# Подкорректируем контроллеры Articles и Comments, чтобы они запрещали доступ для неавторизированных пользователей к функционалу(создание, изменение, удаление статей и комментов), оставив доступ только к просмотру статей и комментов

# /app/controllers/articles_controller.rb:
class ArticlesController < ApplicationController
  # Авторизация только для создания и редактирования статьи
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  # ...
end

# /app/controllers/comments_controller.rb:
class CommentsController < ApplicationController
  # Авторизация только для создания комментария
  before_action :authenticate_user!, :only => [:create]
  # ...
end

# Теперь когда мы переходим например на /articles/new то автоматически переходит на /users/sign_in и возвращает нам представление-devise с уже готовой стандартной формой devise для регистрации(sign up)/авторизации(sign_in).
# Далее мы можем зарегистрироваться, наша User-сущность сохранится в БД и тогда мы получим доступ к экшенам



puts '                                  Добавление нового поля(username)'

# Генератор модели devise по умолчанию не создает столбец username. Можно было использовать и email, который есть по умолчанию, но часто логичнее использовать username, например для комментов в блоге, поэтому добавим его:


# 1. Добавим новый столбец username и индекс для него в таблицу users(Тоже самое можно было сделать изначально дописав нужное поле в фаиле миграции модели User, перед тем как запустили миграцию):
# > rails g migration add_username
# /db/migrate/20190129063426_add_username.rb
class AddUsername < ActiveRecord::Migration[7.0]
  def change # метод change изначально не заполнен
    add_column :users, :username, :string
    # add_column - метод для создания столбца(одного отдельного, для другого нужно писать еще раз add_column ...)
    # :users     - имя таблицы в которую добавим новый столбец
    # :username  - имя нового столбца
    # :string    - тип данных нового столбца
    # (4м аргументом можно поставить значение по умолчанию)

    # Чтобы username были уникальными создадим в БД уникальный индекс/ограничение уникальности:
    add_index :users, :username, unique: true
  end
end
# > rake db:migrate


# 2. Далее, отредактируем форму регистрации Sign Up, для того чтоб там появилось поле для username:
# Сгенерируем набор views(если еще не сгенерин), в том числе там будет и представление с нужной нам формой регистрации.
# > rails g devise:views
# views/devise/registrations/new.html.erb - добавим для sign up поля ввода для username
# layouts/application.html.erb - в лэйаут выведем имя вместо e-mail в приветсвии рядом с Sign Out
# articles/show.html.erb - изменим форму комментов, чтобы при создании комментария в поле автор указывался залогиненый юзер


# 3. Обновим материнский контроллер ApplicationController для того, чтобы в devise можно было использовать username:
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # :configure_permitted_parameters - фильтр, метод ниже.
  # if: :devise_controller? - фильтр будет выполнен только для devise контроллеров.

  protected #private

  # Для Devise надо указать какие дополнительные параметры можно задать.
  def configure_permitted_parameters # метод фильтра с настройками разрешений
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    # :sign_up раздел(тут форма для регистрации нового пользователя)
    # keys: [:username] - то что добавляем в этот раздел.
    # Тоесть мы разрешаем добавление параметра :username, что добавили в форму :sign_up.

    # Эти не использовали, но как вариант других разделов
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end



puts '                 User 1 - * Article. Возможность удалить и редактировать контент только его автору'

# stackoverflow.com/questions/46633649/how-to-allow-users-to-only-see-edit-and-delete-link-if-the-article-is-their-own

# Привяжем сущность Article к пользователю User. Сделаем, чтобы другие пользователи не могли редактировать и удалять статьи.


# 1. Свяжем сущности User и Article

# Добавим столбец с user_id отдельной миграцией
# > rails g migration add_fk_article_to_user
# /db/migrate/20230804075512_add_fk_article_to_user.rb
class AddFkArticleToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :user # foreign key ??
    # В схеме миграйций в таблице articles появятся:
    # t.integer "user_id"
    # t.index ["user_id"], name: "index_articles_on_user_id"
  end
end
# > rake db:migrate

# /models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :articles # добавим
end

# /models/article.rb:
class Article < ApplicationRecord
  has_many :comments, dependent: :destroy

  belongs_to :user, optional: true, required: true # добавим
  # optional: true - если это не добавить то при использовании Rails 5.1 и выше создание новой статьи и тесты этого свойства выдадут ошибку "User must exist"
  # required: true - если не добавить возникнут ошибки с rspec тестирыванием этой ассоциации

  # !!! Но вообще так нельзя и стоит выбрать одно из 2х, тк получается противоречие:
  # optional: true - позволяет сохранять Post без пользователя
  # required: true - требует наличия пользователя (валидация)
end


# 2. Маршруты менять не будем тк сущность User от Devise со своими маршрутами и вкладывать в них нет смысла


# 3. Представления:
# aticles/new.html.erb   - добавим скрытое поле с user_id залогиненного пользователя, чтобы строка статьи содержала значение id пользователя ее создавшего
# aticles/index.html.erb - добавим условия для сокрытия ссылок на редактирование и удаление статьи


# 4. В контроллере article запретим доступ при ручном переходе по URL:
class ArticlesController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  before_action :owner?, only: %i[edit destroy]  # можно так вместо вызова метода owner? в экшенах но, тогда нужно сделать отдельный метод для @article = Article.find(params[:id]) и так же вынести его в свой before_action выше данного, тк метод owner? использует сущность @article

  def edit
    @article = Article.find(params[:id])
    owner? # вызываем метод после определения переменной тк с ней мы сравниваем current_user
  end

  def destroy
    @article = Article.find(params[:id])
    owner? # вызываем метод после определения переменной тк с ней мы сравниваем current_user
    @article.destroy
    redirect_to articles_path
  end

  private

  # добавим разрешения для нового поля user_id в article_params
  def article_params
    params.require(:article).permit(:title, :text, :user_id)
  end

  # кастомный метод перенаправления(переправит на get '\') если ктото решит перейти не по ссылке а ввести URL
  def owner?
    if current_user != @article.user
      # @article.user через объект сущности статьи обращаемся к пользователю которому она пренадлежит и получаем объект этого пользователя, соотв можно обратиться и к полям этого пользователя например article.user.username
      redirect_back fallback_location: root_path, notice: 'User is not owner'
    end
  end
end



puts '                                     Добавить роль администратора'

# https://github.com/heartcombo/devise/wiki/How-To%3A-Add-an-Admin-Role    -   3 варианта(тут использую 2й)


# 1. Создание возможности добавить админа
# Самый простой способ добавить роль администратора — просто добавить атрибут, который можно использовать для идентификации администраторов.

# > rails generate migration add_admin_to_users admin:boolean
class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    # default: false  -  добавим в строку, которая добавляет столбец администратора в таблицу.
  end
end
# > rails db:migrate

# Теперь можно идентифицировать администраторов:
if current_user.admin?
  # do something
end
# Если на странице потенциально может не быть установлен текущий_пользователь, тогда:
if current_user.try(:admin?)
  # do something
end # Так если current_user вернет nil, то не вызовет исключения а просто будет nil.

# Код ниже можно использовать для предоставления статуса администратора текущему пользователю.
current_user.update_attribute :admin, true


# 2. Создание Админа в БД в таблице users
# https://stackoverflow.com/questions/2708417/creating-an-admin-user-in-devise-on-rails-beta-3Ы

# Вариант 1: Просто используйте консоль Rails для создания пользователя-администратора:
# > rails c   (в каждой строке каждую строку ?)
admin = Admin.create! do |u|
u.email = 'sample@sample.com'
u.password = 'password'
u.password_confirmation = 'password'
end
# Теперь просто перейдите по пути входа администратора и войдите в систему

# Вариант 2: Добавить ваших начальных пользователей (и роли, если вы их храните) в фаил db/seeds.rb:
roles = Role.create([{name: 'super_admin'}, {name: 'staff'}, {name:'customer'}]) # этого у меня нет
users = User.create([{email: 'super@test.com', first_name: 'super', last_name: 'admin', password: '@dmin123', password_confirmation: '@dmin123', role: roles[0]}])
# Затем запустите:
# > rake db:seed

# Сделал(на примере blog2) вариантом 1 так
admin = User.create(email: "admin@mail.ru", username: "admin", password: '123456', password_confirmation: '123456', admin: true)



puts '                                  Переопределение devise-контроллеров'

# https://github.com/heartcombo/devise#configuring-controllers

# 1. Генерируем
# > rails generate devise:controllers users -c registrations
# Если не указать -c registrations то сгенерит все контроллеры

# 2. Меняем маршрут в routes.rb
devise_for :users, controllers: { registrations: 'users/registrations' } # было просто devise_for :users

# 3. Рекомендуется, но не обязательно: скопируйте (или переместите) представления из devise/sessions в users/sessions. Rails продолжит использовать представления devise/sessions из-за наследования, если вы пропустите этот шаг, но наличие представлений, соответствующих контроллеру(ам), обеспечивает согласованность.

# 4. Разкомментируем все экшены контроллера, чтобы они работали как задумано
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # Данный экшен будет работать по умолчанию
  def new
    super
  end

  # К данному экшену добавлен функционал на создание еще одной сущности
  def create
    super do |resource|
      Account.create(user_id: resource.id)
    end
  end

  # Данный экшен переопределен полностью, тк убрали super
  def edit
  end
end

















#
