puts '                                             Авторизация'

# Аутентификация - проверка пользователя и пароля
# Авторизация - наделение определёнными правами в зависимости от роли(юзер/админ)

# Тк HTTP это протокол staytless(без состояния), потому после того как сервер возвращает на запрос пользователя данные, соединение сразу обрывается. Соотв технология логина не зависит от соединения.

# Работа технологии: для того чтобы авторизоваться, пользователь подключается к серверу, посылает свой логин и пароль, а сервер возвращает ему уникальный Cookie(токен). Cookie остается у пользователя. Далее когда от данного пользователя поступает следующий запрос, то вместе с ним посылается этот уникальный токен, по нему сервер определяет состояние пользователя. Когда пользователь разлогинивается эта Cookie удаляется. Тоесть куки тут это временный идентификатор пользователя.

# Сервер распознает Cookie с помощью криптографических алгоритмов, которые не требуют обращения к БД. Механизм шифрования основан на цифровой подписи.

# В Rails главный секретный ключ(нужен чтобы устанавливать куки для пользователей) config.secret_key =(изначально закоменчен) находится /config/initializers/devise.rb

# (можно залогиниться автоматически не зная логина и пароля но зная куки для сайта, пока не было разлогина и если куки не привязаны к айпи адресу)


puts
puts '                                               Сессии'

# Механизм сессий(происходит без авторизации)
# ?? в Рэилс приложении это хэш(для каждого пользователя разный)
session['key'] = 'value'
# Механизм сессий выдает Cookie пользователю при первом обращении к серверу, и затем без авторизации идёт обмен данными. Так сервер будет отличать неавторизованных пользователей друг от друга, например для корзины товаров итд.
# Минус сессий в том что они иногда могут быть обнулены, например при перезапуске сервера


puts
puts '                               Базовый способ регистрации и авторизации'

# Rails предоставляет максимально простой вариант системы авторизации на сайте. Все функции и действия уже прописаны но необходимо их активировать. Для добавления авторизации необходимо добавить команду http_basic_authenticate_with в контроллере а также указать логин и пароль.

# Существует две конструкции:
# except (кроме) - указываем страницы что будут доступны для незарегистрированных пользователей;
# only (только) - указываем страницы что будут доступны только для зарегистрированных пользователей.

# На примере blog_ip и его контроллера posts:
class PostsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "123456", except: [:index, :show]
  # except: [:index, :show]  -  страницы на которые может зайти любой гость
  # name: "admin", password: "123456"  - логин или пароль для захода на остальные страницы

  # ... какието экшены и методы ...
end
# В итоге при попытке зайти на не разрешенную гостю страницу, будет вызванно всплывающее окно с выше заданными полями, если значения не верны то перевызовется, если нажать отмена то выдаст пустую страницу с сообщением, а если верны, то произойдет вход
# Пользователь както сохраняется(через куки??)
# Хз как выйти из "акаунта" ??


puts
puts '                               Способы для авторизаци и регистрации на Рэилс'

# 1. Можно использовать строронние решения(гемы), такие как:
# Devise
# Clearance
# Sorcery

# 2. Сделать собственное решение, не такое сложное и навороченое, как например Devise


puts
puts '                               Кастомный способ регистрации и авторизации'

# (На примере AskIt)

# 1. подключим гем bcrypt-ruby для хэширования(криптографич алгоритмы) паролей
# Обычный пароль не подойдет, тк он будет доступен из БД любому разрабу, поэтому нужно хэширование, тоесть делаем из пароля строку символов при помощи хэширования, когда пользователь вводит пароль, он тоже хэшируется и сравниваются 2 эти строки.
# https://github.com/bcrypt-ruby/bcrypt-ruby
# В Gemfile он есть по умолчанию просто его нужно раскомментировать
gem "bcrypt", "~> 3.1.7"
# > bundle i

# В Рэилс уже есть встроенный метод для модели has_secure_password, для работы с bcrypt гемом и виртуальными атрибутами
# https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
has_secure_password(attribute = :password, validations: true)
# password - встроенный виртуальный атрибут, на его основе необходимо назвать наш атрибут XXX_digest и виртуальные атрибуты XXX_confirmation, XXX_challenge


# 2. сгенерируем модель User с использованием в генераторе антрибута password_digest от bcrypt-ruby
# > rails g model User email:string name:string password_digest:string

# Миграция ..._create_users.rb
def change
  create_table :users do |t|
    t.string :email, null: false, index: {unique: true} # Добавим атрибуты null: false - чтобы поле обязательно было заполнено, index: {unique: true} - индекс для ускорения и проверки уникальности имэила, чтобы не было 2 одинаковых. Это проверки на уровне БД, тоесть они будут сделаны любом формате обращения в БД, хоть нарямую, поэтому неплохо самые важные данные проверять и тут, а не только в модели
    t.string :name
    t.string :password_digest

    t.timestamps
  end
end
# > rails db:migrate

# Модель user.rb
class User < ApplicationRecord
  # добавим метод bcrypt-ruby, тут по умолчанию, но можно добавить всякие настройки
  has_secure_password
  # назначим базовые валидации(происходят уже на уровне програмного кода, только при создании через Рэилс):
  validates :email, presence: true, uniqueness: true
  # validates :name, presence: true
end

# Проверим в консоли Рэилс(> rails c)
u = User.new #=> #<User:0x0000015823feddb0 id: nil, email: nil, name: nil, password_digest: nil, created_at: nil, updated_at: nil>

# Метод has_secure_password добавит 2 виртуальных атрибута password и password_confirmation:
u.password #=> nil    # пароль
u.password_confirmation #=> nil   # подтверждение пароля
# виртуальные атрибуты это те, которые можно вызывать на экземпляре класса, но которые не существуют в БД, тоесть ни пароль ни подтверждение пароля не попадут в БД и нужны только для того, чтобы пользователь мог ввести пароль в форму для того чтобы мы его обработали, но в БД попадет только password_digest - хэшированный пароль.

# Зарегистрируемся:
u.password = "test" #=> "test"
u.password_confirmation = "test" #=> "test"
u.email = "test@test.com" #=> "test@test.com"
u.name = "aaa" #=> "aaa"
u.save #=> true # далее видно что в БД создался password_digest - захешированный пароль, значение которого скрыто для доп защиты ??
# INSERT INTO "users" ("email", "name", "password_digest", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["email", "testtest.com"], ["name", "aaa"], ["password_digest", "[FILTERED]"], ["created_at", "2023-11-15 11:45:31.167301"], ["updated_at", "2023-11-15 11:45:31.167301"]]
# Если посмотреть через sqlite3:
# 1|testtest.com|aaa|$2a$12$RdiNXOPOIqzs6dd9mRS.c.AlGKBjWBcalMeKR90g93.0TKd4qCJku|2023-11-15 11:45:31.167301|2023-11-15 11:45:31.167301

# authenticate - метод для того чтобы пустить юзера в систему, он принимает пароль, хэширует его, сравнивает со значением хэшированного пароля в поле password_digest и возврвщает true(объект пользователя) или false
u.authenticate "notright" #=> false
u.authenticate "test" #=> #<User:0x0000015823feddb0 id: 1, email: "testtest.com", name: "aaa", password_digest: "[FILTERED]", created_at: Wed, 15 Nov 2023 11:45:31.167301000 UTC +00:00, updated_at: Wed, 15 Nov 2023 11:45:31.167301000 UTC +00:00>


# 3. Создадим маршруты для users
Rails.application.routes.draw do
  resources :users, only: %i[new create]
end


# 4. создадим контроллер users_controller.rb и представления users/new.html.erb и users/_form.html.erb, а так же добавляем ссылки регистрации в shared/_menu.html.erb
class UsersController < ApplicationController
  def new
    @user = User.new # новый юзер который будет заполняться в форме
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id # используем механизм сессий для того чтобы пустить пользователя в систему(те поставить признак говорящий о том что пользователь зарегистрирован и вошел в систему). Сессия действует только ограниченное время, например пользователь закроет браузер и сессия закончится, те запись из хэша удалится. Сессия не может как куки запоминать пользователя и пускать его например на след день.
      flash[:success] = "Welcome to the app, #{@user.name}!" # можем сразу использовать имя созданной сущьности в сообщении
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end

# 5. Используем session[:user_id] для создания хэлпера текущего пользователя в контроллере, который проверяет вошел пользователь в систему или нет. Добавим его в application_controller.rb:
class ApplicationController < ActionController::Base

  private # ограничим, но можно было бы и вынести эти хэлперы в отдельный concern

  def current_user # подобные вспомогательные методы обычно называют с префиксом current, например current_admin
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
    # Используем значение из сессии, чтобы определить юзера, если такое айди в сессии есть
  end

  def user_signed_in? # для проверки залогинен ли данный пользователь
    current_user.present?
  end

  helper_method :current_user, :user_signed_in? # сделаем данные вспомогательные методы хэлперами, тоесть они будут доступны в представлениях
end


puts
puts '                                          Декораторы. draper'

# Хэлперы лежвт в глобальном пространстве имен, поэтому не всегда стоит их использовать, а можно воспользоваться декораторами
# Декораторы нужны для того, чтобы добавлять к нашим объектам дополнительные методы и эти методы в себя включают логику с отображением именно этого объекта. Это чтото вроде вспомогательных методов но они живут не в глобальном промтранстве имен а только для тех объектов, для которых мы скажем

# draper - гем декоратор
# https://github.com/drapergem/draper
gem 'draper', '~> 4.0'
# > bundle install


puts
# Сделаем при помощи декораторов в _menu.html.erb имя пользователя опциональным, а не обязательным, те если имя пользователя есть, то выводим его, а если нет то возьмем название из имэйла

# 1. Сгенерируем новый application(базовый) декоратор
# > rails generate draper:install
# app/decorators/application_decorator.rb - создалась директория и декоратор
class ApplicationDecorator < Draper::Decorator
end

# 2. Сгенерируем декоратор для User(в нем мы и будем прописывать логику отображения имени)
# > rails generate decorator User
# app/decorators/user_decorator.rb
class UserDecorator < ApplicationDecorator
  delegate_all # это(создано при генерации) нужно чтобы делегировать неизвестные методы самому объекту, который мы декорируем. Например методы типа name email они будут делегированы туда в модель

  # Создадим метод, который будет проверять есть ли у данного объекта имя или нет
  def name_or_email
    return name if name.present? # если имя есть то просто его выведем
    email.split('@')[0] # если имени нет, то сделаем его из имэила, взяв строку до символа @
  end
end

# 3. Задекорируем юзера(сделаем юзера способным вызывать методы декоратора ??) прямо в хэлпере в в application_controller.rb (в том месте где его находим/определяем)
def current_user
  @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
  # decorate - метод который делает объект декорируемым
end

# 4. Теперь мы можем использовать наш метод декоратора name_or_email на юзере в _menu.html.erb

# Теперь когда юзер не введет имя при регистрации, то будет использоваться его преобразованный email
# Естественно в своих декораторах мы можем дополнительно прописать всякий другой функционал

# 5. В users_controller.rb в экшен create тоже нужно добавить наш метод
def create
  @user = User.new user_params
  if @user.save
    session[:user_id] = @user.id
    # flash[:success] = "Welcome to the app, #{@user.name}!" Заменим эту строку на ...
    flash[:success] = "Welcome to the app, #{current_user.name_or_email}!" # можно было бы и задекорировать @user, но удобнее использовать current_user, тк тут он уже доступен тк пользователь зарегистрирован и впущен в систему
    redirect_to root_path
  else
    render :new
  end
end

# 6. Сгенерируем дополнительный декоратор для вопроса для того чтобы поместить в него метод для форматирования даты из модели question.rb
# > rails generate decorator Question
# app/decorators/question_decorator.rb
class QuestionDecorator < ApplicationDecorator
  delegate_all
  def formatted_created_at # перемещаем этот метод из модели question.rb сюда. Тк это относится к логике отображения а не к валидации и тому подобному, то корректнее держать это в декораторе
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
# Далее просто задекорируем объекты в экшенах questions, чтобы все работало
def index
  @pagy, @questions = pagy Question.order(created_at: :desc)#.decorate  - так делать нельзя тк произойдет конфликт decorate с pagy изза чего в пагинации будет отображаться только 1 страница
  @questions = @questions.decorate # задекорируем этот объекты вопросов(так не будет конфликта с pagy).
end
def show
  @question = @question.decorate # добавим эту строку - предварительно задекорируем
  @answer = @question.answers.build
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
end

# 7. Сгенерируем декоратор для ответов с аналогичной целью
# > rails generate decorator Answer
# app/decorators/answer_decorator.rb
class AnswerDecorator < ApplicationDecorator
  delegate_all
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
# Задекорируем объекты в экшенe show questions(тк ответ обрабатывается в нем)
def show
  @question = @question.decorate
  @answer = @question.answers.build
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  @answers = @answers.decorate # декорируем тут
end


puts
# 5. Чтобы не захламлять главный контроллер создадим новый консерн authentication.rb и поместим в него хэлперы из application_controller.rb и подключим его в application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication
end


















#
