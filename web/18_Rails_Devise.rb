puts '                                         Devise. Установка и настройка'

# Devise - гем для авторизации

# !!! Много ошибок решается перезагрузкой сервера Рэилс

# https://github.com/heartcombo/devise
# https://github.com/plataformatec/devise                              -  Документация по гему devise
# https://habr.com/ru/post/208056/                                     -  Статья на Хабре по devise
# https://github.com/plataformatec/devise/wiki/Example-applications    -  Посмотреть примеры как используется
# https://github.com/heartcombo/devise#controller-filters-and-helpers  -  Хэлперы девайс

# Инфа от установщика по донастройке:
# https://github.com/heartcombo/devise/blob/main/CHANGELOG.md
# https://github.com/heartcombo/devise/wiki/How-To:-Upgrade-to-Devise-4.9.0-%5BHotwire-Turbo-integration%5D


# Добавление/подключение в Рэилс приложение:

# 1. Добавим в Gemfile строчку(в конец или начало, не важно):
gem 'devise'

# 2. Запускаем команду
# > bundle

# > rails g    # Проверим какие у нас появились в системе новые генераторы для работы с Devise.
# Devise:
#   devise
#   devise:controllers
#   devise:install
#   devise:views
# Те у нас появился генератор Devise с 4мя опциями(так же добавились devise-опции и в другие разделы)
# ( rails generate devise:controllers users    - контроллеры генерим так)

# 3. Введём:
# > rails g devise:install
# Создались config/initializers/devise.rb  и  config/locales/devise.en.yml.
# Так же вывелись подсказки по настройкам, воспользуемся ими:

#     3-1. Добавим строку(если ее нет) в фаил config/environments/development.rb:
Rails.application.configure do
  # добавим строку:
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # в значении наш локальный адрес
end

#     3-2. Проверить, что в /config/routes.rb указано(добавить если нет):
root to: "home#index"

#     3-3. Добавить(если нет) в Лэйаут нашего приложения app/views/layouts/application.html.erb. Нужно для работы технологии флеш-сообщений:
# <p class="notice"><%= notice %></p>
# <p class="alert"><%= alert %></p>

#     3-4(Это делали ниже а не тут). Для кастомизации форм - можно сделать свои шаблоны для форм(логина, пароля итд) которые выдает гем. Команда автоматически сгенерирует множество директорий и фаилов в views в новой подпапке devise(по умолчанию в каталоге views раздела и представлений для devise нет):
# > rails g devise:views


# !!! После добавления и настройки Devise необходимо перезапустить приложение, иначе возникнут ошибки


puts
puts '                                    Создание devise-модели и миграции'

# Создадим модель пользователя, но при помощи генератора devise вместо model, так модель сразу создастся со всеми полезными свойствами для авторизации: e-mail, зашифрованный пароль, токен для сброса пароля, индексы для таблиц итд итп:

# > rails g devise User

# Создалась миграция db/migrate/20230721073907_devise_create_users.rb
class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token   # токен(символьный код) для сброса пароля
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

# Создалась модель app/models/user.rb(с опциями: регистрация, восстановление пароля итд итп)
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
end

# Запустим миграцию:
# > rake db:migrate


# ПРИМЕЧАНИЕ из комментов(у меня эта ошибка не возникла):
# В Rails 7 может быть ошибка Undefined method 'user_url' при регистрации.
# Нужно в config/initializers/devise.rb добавить/разкомментировать:
# config.navigational_formats = ['*/*', :html, :turbo_stream]


puts
puts '                                  before_action :authenticate_user!'

# Чтобы ограничить доступ неавторизированного пользователя к экшенам контроллера нужно через before_action поставить в контроллере фильтр devise - authenticate_user!.

# 1. Начнем с того что заблокируем все экшены контроллера даже просмотр(/articles) для неавторизированных пользователей
# Откроем /app/controllers/articles_controller.rb и добавим перед экшенами:
class ArticlesController < ApplicationController
  before_action :authenticate_user!
  # before_action - перед работой любого экшена контроллера запускает фильр в аргументе(тут :authenticate_user!). (До Rails 5 у before_action был алиас before_filter, как и многие другие action-свойства включавшие в имени filter)
  # :authenticate_user! - фильтр devise, делает методы контроллера недоступными неавторизованному юзеру и при запрсах будет перенаправлять на форму авторизации devise
end
# Теперь когда мы переходим на /articles то автоматически переходит на /users/sign_in и возвращает нам представление-devise с уже готовой стандартной формой devise для регистрации(sign up)/авторизации(sign_in).
# Далее мы можем зарегистрироваться, наша User-сущность сохранится в БД и тогда мы получим доступ к экшенам


# 2. Добавим ссылки входа и выхода в /app/views/layouts/application.html.erb

# Ссылка выхода по умолчанию не работала(?? по умочанию пост а нужен гет ??), необходимо в route.rb:
devise_for :users # после этой строки...
# написать еще маршрут(юзер в единственном числе):
devise_scope :user do
  get '/users/sign_out' => 'devise/sessions#destroy'
end
# + В config/initializers/devise.rb изменить значение config.sign_out_via
config.sign_out_via = :delete # было это
config.sign_out_via = :get    # изменить на это


puts
puts '                             Добавление нового поля(username) генератором migration'

# Генератор модели devise по умолчанию не создает столбец username. Можно было использовать и email который есть по умолчанию, но часто логичнее использовать username, например для комментов в блоге, поэтому добавим его:

# https://api.rubyonrails.org/classes/ActiveRecord/Migration.html

# 1. Добавим вручную столбец username(Тоже самое можно было сделать изначально дописав нужное поле в фаиле миграции модели User, перед тем как запустили миграцию):
# rails g migration - генератор миграции, который создает миграцию без модели. При помощи него добавим в существующую таблицу users новый столбец, для этого создадим новую миграцию add_username(назвать можно как угодно):
# > rails g migration add_username
# /db/migrate/20190129063426_add_username.rb
class AddUsername < ActiveRecord::Migration[7.0] # При помощи этой миграции можно добавлять в любые таблицы любые новые столбцы
  def change # метод change изначально не заполнен
    add_column :users, :username, :string
    # add_column - метод для создания столбца(одного отдельного, для другого нужно писать еще раз add_column ...)
    # :users - 1й аргумент имя таблицы в которую добавим новый столбец
    # :username - 2й арумент имя нового столбца
    # :string - 3й аргумент тип данных нового столбца
    # (4м аргументом можно поставить значение по умолчанию)

    # По умолчанию можно будет вставить в этот столбец неуникальный username(те может быть 2+ одинаковых). Чтобы это исправить создадим на уровне БД уникальный индекс, который означает, что в этот столбец можно будет вставить только уникальные значения, если будем вставлять неуникальные, то ошибка будет уже на уровне БД.
    # Индекс - это когда для нашей таблицы создается доп таблица, с указателями для более быстрого выбора записей по ключу(полю). Для полей с индексами увеличивается время вставки, но уменьшается время выборки по определённому полю.
    add_index :users, :username, unique: true
    # (Индексы можно добавить и в отдельной миграции, например назвать ее add_index)
  end
end
# > rake db:migrate


# 2. Обновим материнский контроллер ApplicationController для того чтобы в devise можно было использовать username:
# Все контроллеры наследуются от базового контроллера ApplicationController(не имеет своего маршрута) и чтобы задать для всех контроллеров один параметр(например есть какието гемы, как Девайс, требующие особого поведения), надо прописать это в  ApplicationController  /app/controllers/application_controller.rb:
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # :configure_permitted_parameters - фильтр, который будет выполнен только для devise контроллеров.
  # (Девайс контроллер это тот где у нас работает девайс, тут это Articles, тк там подключен девайс при помощи before_action :authenticate_user!  ??   или мб только базовые Devise-контроллеры   ?? )

  protected #private

  # Для Devise надо указать какие дополнительные параметры можно задать.
  def configure_permitted_parameters # метод фильтра с настройками разрешений
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    # :sign_up раздел(тут форма для регистрации нового пользователя)
    # keys: [:username] - то что добавляем в этот раздел.
    # Тоесть мы разрешаем добавление параметра :username для формы :sign_up. (или для занесения в БД из этой формы тк срабатывает перед экшенами девайс ??) Тоесть чтобы при регистрации теперь спрашивало username

    # Эти не использовали но как вариант других разделов
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end


# 3. Далее, отредактируем форму регистрации Sign Up, для того чтоб там появилось поле для username:
# Но по умолчанию в каталоге views раздела и представлений для devise нет, поэтому сгенерируем набор views:
# > rails g devise:views
# Команда автоматически создает множество директорий и фаилов в views в новой подпапке devise, в том числе и фаил отвечающий за представление с нужной нам формой регистрации. Теперь мы можем эти представления изменять

# Теперь добавим для sign up код поля ввода username в /app/views/devise/registrations/new.html.erb
# В лэйаут выведем имя вместо e-mail в приветсвии рядом с Sign Out в /app/views/layouts/application.html.erb


# 4. Подкорректируем контроллеры Articles и Comments, чтобы они запрещали доступ незарегистрированным пользователям только к функционалу(создание, изменение, удаление статей и комментов), но разрешали по умолчанию доступ к просмотру статей и комментов
class ArticlesController < ApplicationController
  # Авторизация только для создания и редактирования статьи /app/controllers/articles_controller.rb:
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  # ... Экшены итд ...
end
class CommentsController < ApplicationController
  # Авторизация только для создания комментария /app/controllers/comments_controller.rb:
  before_action :authenticate_user!, :only => [:create]
  # ... Экшены итд ...
end


# 5. Изменим форму комментов в articles/show.html.erb чтобы при создании комментария в поле автор указывался залогиненый юзер


puts
puts '                 User 1 - * Article. Возможность удалить и редактировать контент только его автору'

# (На примере e:\doc\projects\rubyschool\blog_RoR)
# Привяжем сущность Article к пользователю User. Сделаем, чтобы другие пользователи не могли редактировать и удалять статьи.
# stackoverflow.com/questions/46633649/how-to-allow-users-to-only-see-edit-and-delete-link-if-the-article-is-their-own


# 1. Свяжем сущности User и Article
# /models/article.rb:
class Article < ApplicationRecord
  has_many :comments#, dependent: :destroy    # было в комментах к уроку 46 хз зачем

  belongs_to :user, optional: true, required: true # добавим вручную;
  # optional: true - если это не добавить то при использовании Rails 5.1 и выше создание новой статьи и тесты этого свойства выдадут ошибку "User must exist"
  # required: true - если не добавить возникнут ошибки с rspec тестирыванием этой ассоциации
end

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

  has_many :articles # добавим вручную
end


# 2. Маршруты менять не будем тк сущность User от Devise со своими маршрутами и вкладывать в них нет смысла


# 3. В aticles/new.html.erb добавим скрытое поле с user_id залогиненного пользователя


# 4. В aticles/index.html.erb добавим условия для сокрытия ссылок на редактирование и удаление статьи


# 5. В контроллере article запретим доступ при ручном переходе по URL:
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


puts
puts '                                     Добавить роль администратора'

# https://github.com/heartcombo/devise/wiki/How-To%3A-Add-an-Admin-Role    -   3 варианта(тут использую 2й)


# 1. Создание возможности добавить админа
# Самый простой способ поддержать роль администратора — просто добавить атрибут, который можно использовать для идентификации администраторов.

# > rails generate migration add_admin_to_users admin:boolean
class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    # default: false  -  добавим в строку, которая добавляет столбец администратора в таблицу.
  end
end
# > rails db:migrate

# Теперь можно идентифицировать администраторов:
if current_user.admin?  # со знаком вопроса потому что тип boolean ??
  # do something
end
# Если на странице потенциально может не быть установлен текущий_пользователь, тогда:
if current_user.try(:admin?)
  # do something
end
# При использовании описанного выше способа, если current_user бы было nil, он все равно работал бы, не вызывая undefined method admin? for nil:NilClass исключения.

# Код ниже можно использовать для предоставления статуса администратора текущему пользователю.
current_user.update_attribute :admin, true


# 2. Создание объекта Админа в таблице users
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

















#
