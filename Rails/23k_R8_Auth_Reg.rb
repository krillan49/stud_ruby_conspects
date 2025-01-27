puts '                        Аутентификация со Scaffold, с Rails 8 Generator'

# Rails 8 добавляет встроенный генератор аутентификации, который создает базовые модели, контроллеры, представления, маршруты и т.д, необходимые для базового процесса аутентификации по электронной почте / паролю. Он создает User модель, если таковая еще не существует, в качестве аутентифицируемого объекта. Он использует bcrypt(добавит при генерации) gem для хэширования пароля и т.д.

# Это простой способ добавлять основные функции аутентификации, не полагаясь на сложные все-в-одном gems.

# На Rails 8 стоит начинать свой проект с базовой аутентификации, сразу после генерации нового проета, просто используя генератор аутентификации 'authentication':
# $ bin/rails generate authentication

# Эта команда генерирует необходимые файлы, которые формируют основу для полной системы аутентификации, включая обработку сессии и функциональность сброса пароля.

# Gem bcrypt, используемый для безопасной обработки паролей, добавляется в ваш Gemfile, если он там еще не присутствует или не закомментирован, и bundle install запускается, чтобы убедиться в его доступности.

# Пример того, что создает генератор:
#=>
#   invoke  tailwindcss
#   create    app/views/passwords/new.html.erb
#   create    app/views/passwords/edit.html.erb
#   create    app/views/sessions/new.html.erb
#   create  app/models/session.rb
#   create  app/models/user.rb
#   create  app/models/current.rb
#   create  app/controllers/sessions_controller.rb
#   create  app/controllers/concerns/authentication.rb
#   create  app/controllers/passwords_controller.rb
#   create  app/channels/application_cable/connection.rb
#   create  app/mailers/passwords_mailer.rb
#   create  app/views/passwords_mailer/reset.html.erb
#   create  app/views/passwords_mailer/reset.text.erb
#   create  test/mailers/previews/passwords_mailer_preview.rb
#   insert  app/controllers/application_controller.rb
#    route  resources :passwords, param: :token
#    route  resource :session
#     gsub  Gemfile
#   bundle  install --quiet
# generate  migration CreateUsers email_address:string!:uniq password_digest:string! --force
#    rails  generate migration CreateUsers email_address:string!:uniq password_digest:string! --force
#   invoke  active_record
#   create    db/migrate/20250115224625_create_users.rb
# generate  migration CreateSessions user:references ip_address:string user_agent:string --force
#    rails  generate migration CreateSessions user:references ip_address:string user_agent:string --force
#   invoke  active_record
#   create    db/migrate/20250115224626_create_sessions.rb


# Далее создаем БД:
# $ bin/rails db:create db:migrate

# Создаем тестового пользователя в консоли Rails:
# $ rails c
User.create(email_address: "you@example.com", password: "test-password-123")



puts '                                          Модели и миграции'

# Rails устанавливает модели и миграции для управления учетными записями пользователей и сессияями:

# CreateUsers - миграция создает users таблицу с email_address полем, которое имеет уникальный индекс, и password_digest полем для безопасного хранения паролей с использованием has_secure_password

# CreateSessions - миграция определяет sessions таблицу с token полем (обеспечивающим уникальность), а также поля для ip_address и user_agent для отслеживания устройства и сети пользователя. Модель Session включает в себя has_secure_token генерацию уникальных токенов сессии.

# Current - модель управляет данными по каждому запросу и предоставляет удобный доступ текущему пользователю, используя user метод, который делегирует полномочия сессии.



puts '                                  Контроллеры и консерн Authentication'

# Автоматически создаются при генерации с generate authentication:

# 1. concerns/authentication.rb - concern контроллеров с основной логикой аутентификации (вспомогательными методами). Подключен по умолчанию в application_controller. (Код там)

# 2. session_controller - облегчает обработку сессии пользователя с помощью экшенов (Код там)

# 3. password_controller - управляет процессом сброса и обновления пароля с помощью экшенов (Код там)



puts '                                Свои дополнения для консерна Authentication'

# 1. current_user - добавим метод-хэлпер для возврата текущего пользователя (код в Authentication)



puts '                                      Использование в контроллерах'

# Разработчики Rails работают с двумя типами доступа:
# Публичные страницы для любых посетителей
# Частные страницы для аутентифицированных пользователей

# Генерация базовых контроллеров проекта:
# $ rails g controller home index
# $ rails g controller dashboard show

# Генерация маршрутов:
Rails.application.routes.draw do
  get "home/index", as: :home
  get "dashboard/show", as: :dashboard
  root "home#index"
end

# Контроллер с публичным доступом:
class HomeController < ApplicationController
  allow_unauthenticated_access(only: :index)  # метод консерна разрешает заходить без утентификации только на index, при переходе на другой экшен вернет страницу регистрации
  def index # Get /home будет доступен всем
  end
end

# Контроллер с ограничением доступа в зависимости от аутентификации:
class DashboardController < ApplicationController
  before_action :resume_session, only: [:show]
  def show # /dashboard Требуется вход в систему
  end
end


# Попробуйте эти задачи:
# Создайте процесс регистрации
# Создать сброс пароля
# Добавить сохранение сессии
# Оформите свои шаблоны ERB
# Следующие шаги для разработчиков Rails

# Вы можете расширить это:
# Добавить поддержку OAuth
# Создать роли администратора
# Добавить API-аутентификацию
# Создание профилей пользователей













#
