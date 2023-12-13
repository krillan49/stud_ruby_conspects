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

# 2. Сделать собственное решение (например не такое сложное и навороченое)


puts
puts '                               Кастомный способ регистрации и авторизации'

# (На примере AskIt)

# 1. подключим гем bcrypt-ruby для хэширования паролей (криптографич алгоритмы)
# https://github.com/bcrypt-ruby/bcrypt-ruby
gem "bcrypt", "~> 3.1.7" # В Gemfile он есть по умолчанию просто его нужно раскомментировать
# > bundle i

# Обычный пароль не подойдет, тк он будет доступен из БД любому разрабу, поэтому нужно хэширование, тоесть делаем из пароля строку символов при помощи хэширования, когда пользователь вводит пароль при логине, он тоже хэшируется и сравниваются 2 эти зашифрованные строки.

# В Рэилс уже есть встроенный метод bcrypt гема для модели - has_secure_password
# https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
has_secure_password(attribute = :password, validations: true) # опции метода по умолчанию ??
# password - встроенный виртуальный атрибут, на его основе необходимо назвать наш атрибут для таблицы с хэшированным паролем XXX_digest и виртуальные атрибуты XXX_confirmation, XXX_challenge.
# validations: true  - по умолчанию проводит валидации своих атрибутов ??


# 2. сгенерируем модель User с колонкой для хэшированного пароля password_digest (== атрибуту метода has_secure_password)
# > rails g model User email:string name:string password_digest:string

# Миграция ..._create_users.rb
def change
  create_table :users do |t|
    t.string :email, null: false, index: {unique: true} # Добавим атрибуты null: false - чтобы поле обязательно было заполнено, index: {unique: true} - индекс для ускорения и проверки уникальности имэила и чтобы не было 2 одинаковых. Это проверки на уровне БД, тоесть они будут сделаны любом формате обращения в БД, хоть нарямую, поэтому неплохо самые важные данные проверять и тут, а не только в модели
    t.string :name
    t.string :password_digest

    t.timestamps
  end
end
# > rails db:migrate

# Модель user.rb
class User < ApplicationRecord
  # добавим метод bcrypt-ruby (можно добавить всякие настройки к нему) чтобы создать атрибуты и добавить метод authenticate
  has_secure_password
  # назначим базовые валидации(происходят уже на уровне програмного кода, только при создании через Рэилс):
  validates :email, presence: true, uniqueness: true
end

# Проверим в консоли Рэилс(> rails c)
u = User.new #=> #<User:0x0000015823feddb0 id: nil, email: nil, name: nil, password_digest: nil, created_at: nil, updated_at: nil>

# Метод has_secure_password добавит 2 виртуальных атрибута password и password_confirmation:
u.password #=> nil                # пароль
u.password_confirmation #=> nil   # подтверждение пароля

# Виртуальные атрибуты это те, которые можно вызывать на экземпляре модели, тоесть существуют в модели, но которые не существуют в БД, тоесть ни пароль ни подтверждение пароля не попадут в БД и нужны только для того, чтобы пользователь мог ввести пароль в форму для того чтобы мы его обработали, но в БД попадет только password_digest - хэшированный пароль.

# Зарегистрируемся:
u.password = "test" #=> "test"
u.password_confirmation = "test" #=> "test"
u.email = "test@test.com" #=> "test@test.com"
u.name = "aaa" #=> "aaa"
u.save #=> true # далее видно что в БД создался password_digest - захешированный пароль, его значение скрыто для доп защиты
# INSERT INTO "users" ("email", "name", "password_digest", "created_at", "updated_at") VALUES (?, ?, ?, ?, ?)  [["email", "testtest.com"], ["name", "aaa"], ["password_digest", "[FILTERED]"], ["created_at", "2023-11-15 11:45:31.167301"], ["updated_at", "2023-11-15 11:45:31.167301"]]
# Если посмотреть через sqlite3:
# 1|testtest.com|aaa|$2a$12$RdiNXOPOIqzs6dd9mRS.c.AlGKBjWBcalMeKR90g93.0TKd4qCJku|2023-11-15 11:45:31.167301|2023-11-15 11:45:31.167301

# authenticate - метод для того чтобы пустить(проверить) юзера в систему, он принимает пароль(строку), хэширует его, сравнивает со значением хэшированного пароля в поле password_digest и возврвщает true(объект пользователя) или false
u.authenticate "notright" #=> false
u.authenticate "test" #=> #<User:0x0000015823feddb0 id: 1, email: "testtest.com", name: "aaa", password_digest: "[FILTERED]", created_at: Wed, 15 Nov 2023 11:45:31.167301000 UTC +00:00, updated_at: Wed, 15 Nov 2023 11:45:31.167301000 UTC +00:00>


# 3. Создадим маршруты для users
Rails.application.routes.draw do
  resources :users, only: %i[new create]
end


# 4. создадим контроллер users_controller.rb и представления users/new.html.erb и users/_form.html.erb, а так же добавляем ссылку регистрации в shared/_menu.html.erb
class UsersController < ApplicationController
  def new
    @user = User.new # новый юзер который будет заполняться в форме
  end

  def create
    @user = User.new user_params # has_secure_password используется тут ?
    if @user.save
      session[:user_id] = @user.id # используем механизм сессий для того чтобы пустить пользователя в систему(те поставить признак говорящий о том что пользователь зарегистрирован и вошел в систему). Сессия действует только ограниченное время, например пользователь закроет браузер и сессия закончится, те запись из хэша удалится. Сессия не может как куки запоминать пользователя и пускать его например на след день.
      flash[:success] = "Welcome to the app, #{@user.name}!" # можем сразу использовать имя созданной сущности в сообщении
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

# 5. Создадим хэлперы current_user (возвращает текущего пользователя) и user_signed_in? (проверяет что пользователь залогинен а не гость) при помощи session[:user_id] в контроллере application_controller.rb:
class ApplicationController < ActionController::Base

  private

  def current_user # подобные вспомогательные методы обычно называют с префиксом current, например current_admin
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present?
    # session[:user_id] - используем значение из сессии, чтобы найти и определить юзера, если такое айди в сессии есть
    # @current_user - присваиваем в переменную от которой будем вызывать методы(вернется хэлпером)
  end

  def user_signed_in? # для проверки залогинен ли данный пользователь
    current_user.present?
  end

  helper_method :current_user, :user_signed_in? # сделаем данные вспомогательные методы хэлперами
end

# 5-б. Чтобы не захламлять главный контроллер создадим новый консерн authentication.rb и поместим в него хэлперы из application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication # подключим консерн authentication.rb в application_controller.rb
end


puts
puts '                                          Декораторы. draper'

# Хэлперы лежат в глобальном пространстве имен, поэтому не всегда стоит их использовать, а можно воспользоваться декораторами

# Декораторы нужны для того, чтобы добавлять к нашим объектам дополнительные методы и эти методы в себя включают логику с отображением именно этого объекта. Это чтото вроде вспомогательных методов но они живут не в глобальном промтранстве имен а только для тех объектов, для которых мы их назначим

# ?? Декоратор это управляющая прослойка/фильтр над моделью ??

# draper - гем декоратор
# https://github.com/drapergem/draper
gem 'draper', '~> 4.0'
# > bundle install


puts
# Сделаем при помощи декораторов в _menu.html.erb имя пользователя опциональным, а не обязательным, те если имя пользователя есть, то выводим его, а если нет то возьмем название из имэйла

# 1. Сгенерируем application декоратор (базовый)
# > rails generate draper:install
# app/decorators/application_decorator.rb - создалась директория и материнский декоратор
class ApplicationDecorator < Draper::Decorator
end

# 2. Сгенерируем декоратор для User(в нем мы и будем прописывать логику отображения имени)
# > rails generate decorator User
# app/decorators/user_decorator.rb
class UserDecorator < ApplicationDecorator
  delegate_all # это(создано при генерации) нужно чтобы делегировать неизвестные методы(изначальные методы, например name email) в модель самому объекту, который мы декорируем. Тоесть если декорируемый объект вызовет метод которого нет в декораторе, то этот метод он получит от модели. Тоесть это чтото вроде super ??

  # Создадим метод, который будет выполнять метод name если имя есть у объекта иначе вернет распарсеный email
  def name_or_email
    return name if name.present? # если имя есть то просто его выведем
    email.split('@')[0] # если имени нет, то сделаем его из имэила, взяв строку до символа @
  end
end

# 3. Задекорируем юзера(сделаем юзера способным вызывать методы декоратора ??) прямо в хэлпере в application_controller.rb(или в соотв консерне) те в том месте где его находим/определяем
def current_user
  @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
  # decorate - метод который делает объект декорируемым(?? переключает обработку методов от модели в декоратор ??)
end

# 4. Теперь мы можем использовать наш метод декоратора name_or_email на юзере в _menu.html.erb

# Теперь когда юзер не введет имя при регистрации, то будет использоваться его преобразованный email
# Естественно в своих декораторах мы можем дополнительно прописать всякий другой функционал

# 5. В users_controller.rb в экшен create тоже стоит добавить наш метод name_or_email вместо name
def create
  @user = User.new user_params
  if @user.save
    session[:user_id] = @user.id
    flash[:success] = "Welcome to the app, #{current_user.name_or_email}!" # можно было бы и задекорировать @user, но удобнее использовать current_user, тк тут он уже доступен тк пользователь зарегистрирован и впущен в систему
    redirect_to root_path
  else
    render :new
  end
end


puts
# 6. Сгенерируем дополнительные декораторы для вопроса и ответа для того чтобы поместить в них методы для форматирования даты из моделей question.rb и answer.rb:

# > rails generate decorator Question
# app/decorators/question_decorator.rb
class QuestionDecorator < ApplicationDecorator
  delegate_all
  def formatted_created_at # перемещаем этот метод из модели question.rb сюда. Тк это относится к логике отображения а не к валидации и тому подобному, то корректнее держать это в декораторе
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end

# > rails generate decorator Answer
# app/decorators/answer_decorator.rb
class AnswerDecorator < ApplicationDecorator
  delegate_all
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end

# Далее просто задекорируем объекты в экшенах контроллера questions, чтобы все работало
def index
  @pagy, @questions = pagy Question.order(created_at: :desc)#.decorate  - так делать нельзя тк произойдет конфликт decorate с pagy изза чего в пагинации будет отображаться только 1 страница
  @questions = @questions.decorate # задекорируем объект вопросов отдельно(так не будет конфликта с pagy).
end
def show
  @question = @question.decorate # добавим эту строку - предварительно задекорируем
  @answer = @question.answers.build
  @pagy, @answers = pagy @question.answers.order(created_at: :desc)
  @answers = @answers.decorate # декорируем answers тут в экшенe show questions(тк ответ обрабатывается в нем)
end


puts
puts '                   Log in и Log out(вход и выход из системы/создание и удаление сессии)'

# Для этого создадим отдельные маршруты и контроллер для сессий(создания и удаления, тоесть входа и выхода из системы). (можно было бы создать доп маршруты и экшены для контроллера пользователя, но это было бы не лучшее решение)

# 1. Создадим новый ресурс с маршрутами для создания(входа в систему) и удаления(выхода из системы) сессии
Rails.application.routes.draw do
  resource :session, only: %i[new create destroy] # создадим новый ресурс
  # тут мы создаем именно ресурс, а не ресурсы, соответсвенно и :session корректнее в единственном числе
end

# 2. Добавим в _menu.html.erb:
# ссылку входа в систему(создание сессии) на URL new_session_path те GET '/session/new'
# ссылку выхода из системы(удаление сессии) на URL session_path те DELETE '/session'

# 3. Создадим контроллер сессий sessions_controller.rb
class SessionsController < ApplicationController
  def new
    # Никакого объекта создавать не нужно, тк ничего в базу вноситься не будет, а в форму просто введем URL
    # вернет вид с формой sessions/new.html.erb
  end

  def create # Ничего в БД помещать не будем, а просто проверим пароль и впустим пользователя или нет
    user = User.find_by email: params[:email] # ищем пользователя по его имэйлу (используем параметры по отдельным полям)
    if user&.authenticate(params[:password]) # используем метод authenticate для того чтобы проверить пользователя, захешировав введенный пароль и сравнив его с хэшированным паролем из БД.
    # & - добавим амперсант, тк user может вернуть nil и соотв вызов метода выдаст ошибку, а данный синтаксис вместо вызова метода в случае нил просто вернет nil

      # вар 1 создаем для юзера сессию если все ок
      session[:user_id] = user.id
      # вар 2 но лучше вынести это в наш консерн authentication.rb в отдельный метод(тк далее эта логика может стать сложнее)
      sign_in(user) # тоже применим и в контроллере юзеров

      flash[:success] = "Welcome back, #{current_user.name_or_email}!"
      redirect_to root_path
    else
      # вариант 1
      flash[:warning] = "Incorrect email and/or password!" # не будем сообщать что именно введено неправильно, чтобы не упрощать жизнь злоумышленникам
      redirect_to new_session_path
      # вариант 2. Если мы хотим заново отрендерить форму, то к флэш сообщению нужно применить метод now
      flash.now[:warning] = "Incorrect email and/or password!"
      render :new
    end
  end

  def destroy # обычно когда мы чтото удаляем то передает какойто айди, но тут мы удаляем сессию которую не храним в БД

    # вар 1 удаляем сессию юзера и заодно разопределим переменную текущего юзера
    session.delete :user_id # :user_id - ключ хэша-сессии, current_user.id его значение ??
    @current_user = nil
    # вар 2 тоже лучше вынести это в наш консерн authentication.rb
    sign_out

    flash[:success] = "See you later!"
    redirect_to root_path
  end

  # Разрешать параметры нам тут не нужно, тк ни в какие БД данные в этом контроллере заноситься не будут
end


puts
puts '                    Возможность переходить на страницы входа, регистрации итд'

# Запретим пользователю вход, на страницу регистрации или новой сессии, если пользователь уже находится в системе(существует сессия). И наоборот запретим невошедшим удалять сессию
# Для этого создадим в консерне authentication.rb вспомогательные функции и повесим их на before_action в контроллерах

class UsersController < ApplicationController
  before_action :require_no_authentication
end

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: :destroy
end


puts
puts '                             Редактирование профиля пользователя(User)'

# 1. Добавим в маршруты юзера новые экшены edit и update
Rails.application.routes.draw do
  resources :users, only: %i[new create edit update]
end


# 2. создадим users/edit.html.erb и добавим в shared/_menu.html.erb ссылку GET 'users/:id/edit', так же чтобы использовать ту же форму что и для создания _form.html.erb немного подкорректируем ее


# 3. Изменим контроллер users_controller.rb
class UsersController < ApplicationController
  before_action :require_no_authentication, only: %i[new create] # добавим  only: %i[new create]
  before_action :require_authentication, only: %i[edit update] # добавим
  before_action :set_user!, only: %i[edit update] # @user = User.find params[:id] для этих экшенов

  # экшены new и create не изменились

  def edit
  end

  def update
    if @user.update user_params
      flash[:success] = "Your profile was successfully updated!"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  private

  def set_user! # добавим
    @user = User.find params[:id]
  end

  # user_params пока не изменился
end


puts
puts '                         Проверка корректности введенного имэйла в валидации'

# Чтобы проверить вообще соответсвует ли введенный текст имэйлу, а не какойто херней

# 1. Задействуем сторонний гем valid_email2. Тк он умеет проверять не только корректность имэйла, но и по ДНСу может проверять существует ли такая доменная зона вообще или нет, а так же всякое другое, что можно дополнительно подключать в валидациях
# https://github.com/micke/valid_email2
# Добавим в Gemfile:
gem "valid_email2"
# > bundle
# Или если простая установка
# > gem install valid_email2

# 2. Модель user.rb
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  # 'valid_email_2/email': true  - собственно проверка гемом на коррктность формата имэйла
end


puts
puts '                   Защита при редактировании пользователя. old_password + валидации'

# Лучше сделать требования введения старого пароля при редактировании пользователя(особенно для смены пароля), на случай, если ктото полоучит доступ(например пользователь забыл выйти и ктото сел за его аккаунтом)

# 1. Добавим собственно новое поле для ввода старого пароля в форму users\_form.html.erb

# 2. Разрешим поле старого пароля в контроллере users_controller.rb (но сравнивать будем в модели)
class UsersController < ApplicationController
  # ...
  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :old_password)
  end
end

# 3. В модели user.rb создадим новые валидации, в том числе и кастомные и переопределим валидации метода has_secure_password
class User < ApplicationRecord
  attr_accessor :old_password # добавим новый виртуальный атрибут в модель, тк будем вводить в него данные в форме

  has_secure_password validations: false # отключим встроенные валидации атрибутов bcrypt, чтобы написать их самим

  # ?? Отличия validate от validates ??

  validate :password_presence # тк ниже в валидацию :password добавлено allow_blank: true, это значит что пароль может быть пустым во всех случаях, даже при создании нового юзера, что естественно нам не подходит, поэтому сделаем кастомную валидацию (метод ниже), для того чтобы запретить пустое поле пароля если это форма создает нового пользователя

  validate :correct_old_password, on: :update, if: -> { password.present? } # наш кастомный метод валидации для проверки правильности старого пароля(сравнение с тем что в модели или БД)
  # on: :update - валидация будет происходить только при обновлении записи, а при создании нового юзера нет
  # if: -> { password.present? } - (если не хотим чтобы спрашивало старый пароль при изменении чего угодно кроме пароля) поставим такую лямбду и валидация будет происходить только если новый пароль был указан, тоесть не пустой, тоесть только если меняем и пароль

  validates :password, confirmation: true, allow_blank: true, length: {minimum: 8, maximum: 70}
  # confirmation: true - значит что значение поле :password должно совпадать со значением в поле :password_confirmation, тоесть пароль в фрмедолжен быть подтвержден
  # allow_blank: true - при редактировании учетной записи можно оставить поле пустым(когда не хотим менять пароль, тк по умолчанию поле пароля в форме edit не заполняется автоматически как все остальные)

  validate :password_complexity # наш кастомный метод валидации(сам метод ниже) для проверки сложности пароля

  private

  def correct_old_password
    # return if authenticate(old_password) - так делать нельзя(если нам удалось аутентифицировать пользователя со старым паролем это значит он правильный), тк есть баг, что сравнивает с новым сгенереным в памяти хэшированным паролем, а не со старым, если новый и старый пароли ввести одинаковыми
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password) # поэтому придется вызывать методы BCrypt напрямую (тут мы ничего не делаем если введенный старый пароль соответсвует старому паролю из БД)
    # password_digest_was - это специальный метод созданный Rails автоматически - берет хэшированный пароль из БД
    # is_password?(old_password) - сравниваем со значением (предварительно хешируя его) введенным в поле old_password

    errors.add :old_password, 'is incorrect' # вызываем ошибку валидации с сообщением если значение в поле старый пароль неправильное (не соответсвует паролю из БД)
  end

  def password_complexity # https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a  - взято отсюда(Девайс)
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
    # Если пароль пустой или соответсвует регулярке, то ничего не делает, а если нет то запускается ошибка валидации неже
    errors.add :password, 'complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character' # запускает ошибку валидации и выводит сообщение
  end

  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
    # запускаем ошибку валидации при пустом поле пароля, только если password_digest еще не существует в БД, тоесть при создании нового профиля пользователя
  end
end


puts
puts '                        Запоминание авторизированного пользователя в БД(куки)'

# ?? Почемуто когда ставим галочку пускает с неверным паролем в акаунт. Мб изза метода update_column, тк все валидации прпускаются ??

# Можно запомнить пользователя в куки, а не только в сессии, например закрыли браузер без выхода, то сессия удалилась, но хэшированный токен остался в БД и его можно сверить с куки в браузере.
# Тоесть запоминание - генерируем токен, хэшируем, помещаем в БД и в куки браузера, забывание - удаляем токен из БД и браузера.

# Куки и сессии можно посмотреть в консоли браузера в разделе Application


# 1. Добавим чекбокс в форму сессии sessions/new.html.erb для того чтобы пользователь выбрал запоминать или нет его в куки


# 2. Добавим в таблицу users новое поле remember_token_digest, которое будет содержать хэшированный токен при помощи которого мы будем запоминать пользователя
# > rails g migration add_remember_token_digest_to_users remember_token_digest:string
class AddRememberTokenDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :remember_token_digest, :string
  end
end
# > rails db:migrate


# 3. В модели user.rb. Создадим методы для запоминания пользователя(сгенерируем токен и поместим его в таблицу) и для забывания пользователя(соотв удаления токена из БД)
class User < ApplicationRecord
  # ...
  attr_accessor :remember_token # создадим виртуальный атрибут для токена

  # ...

  # метод запоминающий пользователя(создает и помещяет токен в таблицу)
  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    # SecureRandom.urlsafe_base64 - генерируем токен
    # self.remember_token - помещаем сгенерированный токен в виртуальный атрибут юзера(переменная экземпляра)
    update_column :remember_token_digest, digest(remember_token) # remember_token - можно и без self
    # update_column - метод помещающий чтото в колонку таблицы
    # :remember_token_digest - имя столбца в который помещаем
    # digest(remember_token) - значение которое помещаем (тут метод digest возвращает хэшированный токен)
  end

  # метод забывающий пользователя(удаляем токен из БД)
  def forget_me
    update_column :remember_token_digest, nil # тоесть ставим значение nil в колонке remember_token_digest вместо токена
    self.remember_token = nil # (не обязательно) заодно разопределим и переменную экземпляра
  end

  # метод для сравнения передаваемого токена(будет захеширован) и хэшированного токена из БД
  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank? # вернем false если в поле токена null
    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
    # те сравниваем хэш токена из БД remember_token_digest с токеном remember_token, который передаем в метод
  end

  private

  # метод хэширования токена, генерирует хэш из строки токена (используем в нем код "украденый" из has_secure_password)
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ...
end


# 4. В контроллеле sessions_controller.rb собственно запомним пользователя в зависимости от значения чекбокса
class SessionsController < ApplicationController
  # ...
  def create
    user = User.find_by email: params[:email]
    remember(user) if params[:remember_me] == '1' # запоминаем пользователя, только если в чекбоксе стоит галочка('1')
    # remember(user) - напишем эту вспомогательную функцию в консерне authentication.rb
    if user&.authenticate(params[:password])
      sign_in user
      flash[:success] = "Welcome back, #{current_user.name_or_email}!"
      redirect_to root_path
    else
      flash.now[:warning] = "Incorrect email and/or password!"
      render :new
    end
  end
  # Или отрефакторим по рекомендации рубокопа(вынесем логику входа в систему в подметод)
  def create
    user = User.find_by email: params[:email]
    if user&.authenticate(params[:password])
      do_sign_in user
    else
      flash.now[:warning] = 'Incorrect email and/or password!'
      render :new
    end
  end
  private
  def do_sign_in(user)
    sign_in user
    remember(user) if params[:remember_me] == '1'
    flash[:success] = "Welcome back, #{current_user.name_or_email}!"
    redirect_to root_path
  end
  # ...
end


# 5. так же в консерне authentication.rb:
# модифицируем хэлпер current_user, чтобы он определял пользователя по куки если у него нет сессии
# добавим функцию forget забывающую пользователя(те удаляющий токен из куки), запускать ее будем в методе sign_out, но можно и в экшене sessions#destroy
















#
