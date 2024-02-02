puts '                      Отправка писем (ActionMailer, letter_opener) и сброс пароля'

# На примере AskIt. Создадим отдельный маршрут, контроллер и представление, где пользователь сможет(без входа на свой профиль, где он и так может все поменять, но например пользователь забыл свой пароль) ввести свой имэйл адрес и нажать кнопку "сбросить пароль", после отправки этой формы пользователю на почту придет уникальная ссылка, в ней будет специальный защитный токен, после сброса данный токен становится невалидным, а у пользователя появляется новый пароль.


# 1. Создадим новый маршрут для контроллера сброса пароля в routes.rb
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    resource :password_reset, only: %i[new create edit update]
    # resource - создаем именно ресурс, а не ресурсы, тк ни с какими id работать не будем, а только с записью юзера по имэйл
    # new create - для того чтобы запросить у пользователя инструкции для сброса пароля и отправить ему письмо
    # edit update - для того чтобы сбросить пароль
  end
end


# 2. Создадим директорию для представлений сброса пароля /password_resets
# password_resets/new.html.erb - создаем представление с формой, где можно запросить сброс пароля
# sessions/new.html.erb - добавим кнопку "забыл пароль" с которой и вызовется форма выше


# 3. В Рэилс уже есть базовый функционал, который позволяет отправлять почту:
# app/mailers/application_mailer.rb - базовый класс мэйлера от которого мы можем наследовать
class ApplicationMailer < ActionMailer::Base
  default from: 'admin@askit.com' # тут мы можем написать(изменить) от кого(сервер) будут письма приходить (пофиг что ??)
  layout 'mailer' # тут указывается специальный лэйаут для писем
end

# Лэйауты для писем находятся в директории лэйаутов(код там же) вместе с обычным лэйаутом:
# layouts/mailer.html.erb  - для письма в формате html
# layouts/mailer.text.erb  - для письма в формате плэйнткста
# Лэйаута 2 так как разные почтовые клиенты предпочитают разные форматы писем, поэтому всегда будет отправлено 2 письма обоих форматов

# Создадим новый мэйлер mailers/password_reset_mailer.rb, через который мы будем отправлять почту с данными по смене пароля
class PasswordResetMailer < ApplicationMailer # мэйлеры обычно именуются в единственном числе
  # Создадим метод при помощи которого будет отправляться почта(название любое)
  def reset_email
    @user = params[:user]
    # :user - сущность юзера в парамс установлена при вызове данного метода из контроллера PasswordResetsController#create

    mail to: @user.email, subject: I18n.t('password_reset_mailer.reset_email.subject')
    # mail - метод отправляющий почту, может принимать много разных параметров
    # to: @user.email  - кому отправляем, тут на имэйл юзеру
    # subject: I18n.t('password_reset_mailer.reset_email.subject')   - тема письма
  end
end


# 4. Создадим контроллер password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_action :require_no_authentication # пароль можно сбрасывать только тем кто еще не вошел в систему (залогеные и сами могут)

  # Экшен create тут будет отправлять инструкции для сброса пароля
  def create
    @user = User.find_by email: params[:email] # находим юзера по указанному пользователем в форме имэйлу

    if @user.present? # если юзер нашелся в БД
      # Вызываем метод reset_email мэйлера PasswordResetMailer для отправки почты:
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
      # with(user: @user) - устанавливаем ключ и значение для params[:user]
      # deliver_later - отправить позже, поставит отправку письма в очередь и она произойдет уже в фоновом режиме(нужно настроить иначе будет тоже как и deliver_now). Желательно использовать его если отправляем письма из контроллера, если отправляем из самих фоновых задач, то уже бессмысленно
      # deliver_now - отправить сейчас, это значит пока письмо не уйдет метод будет постоянно пытаться кго отправить, соотв страница у пользователя будет грузиться и ему придется ждать, чтоб перейти на другую
    end
    flash[:success] = t '.success' # в любом случае саксесс, чтоб злоумышленники не угадывали пароли
    redirect_to new_session_path # на страницу логина
  end
end


# 5. Создадим собственно письмо, которое отправим. Для этого в представлениях создадим дирректорию /password_reset_mailer с представлениями, только представлениями не для контроллера, а для мэйлера, которые собственно и будут рендерить письма. Называем представления точно так же как и имя метода(reset_email) в мэйлере, который отправляет письмо, чтобы метод вызывал одноименное представление по умолчанию(суть такая же как и с именами экшенов контроллера):
# reset_email.html.erb  - для письма в формате html
# reset_email.text.erb  - для письма в формате text


puts
puts '                                             letter_opener'

# Но чтобы отправить письмо нужен какой-то почтовый сервер, настройка почтового сервеса, это вещь отдельная и она зависит от того где будет хоститься наше приложение, обычно на хостинге есть и свои варианты, так же есть сервисы типа СантГрид и МэилГАн, с помощью которых можно нстроить отправку писем. Но это все для развертывание в продакшене, в девелопмент среде лучше использовать локальный вариант.

# letter_opener - гем позволяет тестировать отправку писем без почтового сервера, локально, отаправляет результат нам же в браузер

# https://github.com/ryanb/letter_opener

# Если приложение работает не на локальном а на стороннем сервере, то придется искать альтернативные решения, которые описаны в разделе Remote Alternatives доков на гитхабе


# Gemfile:
gem "letter_opener", group: :development
# > bundle i


# Настроим в config/environments/development.rb добавим строки:
config.action_mailer.perform_caching = false
# строка выше уже была, после нее добавим:
config.action_mailer.delivery_method = :letter_opener # те отправка писем будет производиться через данный гем(в environments/production.rb тут будет чето другое например SMTP)
config.action_mailer.perform_deliveries = true # тк по умолчанию в девелопмент среде письма не отправляются вовсе
config.action_mailer.default_url_options = { host: 'localhost:3000' } # адрес нашего хоста, нужен для того, чтобы генерировать полные URL адреса ссылок для перехода от нашего письма в почтовом клиенте пользователя, например к активации сброса пароля


# Теперь можно тестировать и вводить почту(любую например test@example.com) на http://localhost:3000/en/password_reset/new.
# В контроллере для простоты можно выбрать 1го юзера для тестирования
def create
  PasswordResetMailer.with(user: User.first).reset_email.deliver_later
end
# И нам придет фаил в браузер file:///E:/doc/Projects/stud_other/AskIt/tmp/letter_opener/1706451271_2364283_6fa6272/rich.html с телами обоих писем, например:
#    From: admin@askit.com
# Subject: Password reset | AskIt
#    Date: Jan 28, 2024 05:14:31 PM RTZ 2 (чшьр)
#      To: testtest.com
# ---------------------------------------------------------
# Someone has requested password reset for your account.
# Так же в журнале событий в консоли будет вся информация, в том числе и код разметки с лэйаутами


puts
puts '                                       Токен для сброса пароля'

# Нам неоходимо сгенерировать специальный токен, с помощью которого мы сможем идентифицировать что это тот пользователь, который имеет на это право, а не какойнить злоумышленник сбрасывает пароль


# 1. Сгенерируем миграцию для для добавления в таблицу users поля для токена сброса пароля и колонки времени создания этого токена
# > rails g migration add_password_reset_token_and_password_reset_token_sent_at_to_users password_reset_token:string:index password_reset_token_sent_at:datetime
class AddPasswordResetTokenAndPasswordResetTokenSentAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_reset_token, :string
    add_index :users, :password_reset_token
    add_column :users, :password_reset_token_sent_at, :datetime
  end
end
# > rails db:migrate
create_table "users", force: :cascade do |t|
  # ...
  t.string "password_reset_token"
  t.datetime "password_reset_token_sent_at"
  t.index ["password_reset_token"], name: "index_users_on_password_reset_token"
end


# 2. Напишем метод генерации токена. Можно было бы сделать и в модели user.rb, но она и так слишком разрослась, потому создадим новый консерн моделей concerns/recoverable.rb и создадим в нем собственно метод set_password_reset_token (код там)
include Recoverable # не забываем подключить консерн в модель user.rb


# 3. Задействуем токены в представлениях, добавив их в URL адрес ссылки reset_email.html.erb и reset_email.text.erb


# 4. Метод генерации будет запускаться в контроллере в экшене create, чтобы передать его в письме
class PasswordResetsController < ApplicationController
  before_action :require_no_authentication
  before_action :check_user_params, only: %i[edit update] # проверка на то есть ли вообще params[:user], тк у нас в set_user он используется в связке params[:user][:email] и params[:user][:password_reset_token]
  before_action :set_user, only: %i[edit update] # для определения пользователя по токену и имэйлу

  def create # отправляем письмо со ссылкой и токеном на сброс пароля
    @user = User.find_by email: params[:email]
    if @user.present?
      @user.set_password_reset_token
      # set_password_reset_token - метод генерирует токен, название любое
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
    end
    flash[:success] = t '.success'
    redirect_to new_session_path
  end

  # GET 'http://localhost:3000/password_reset/edit?user%5Bemail%5D=ser%40ser.com&user%5Bpassword_reset_token%5D=%242a%2412%24dN7sWvGTA.557iJMy3fQWOatL8ddPP151iN4KRHO6FB50pZrpySgC'
  # Если мы изменим токен в адресе то сменить пароль недаст
  def edit
    # Возвращает форму в которую заодно передадим данные токена и имэйла из параметров URL через set_user
  end
  # password_resets/edit.html.erb - создадим представление с формой, в которую пользователь введет новый пароль

  def update # собственно обновляем пароль
    if @user.update user_params
      flash[:success] = t '.success'
      redirect_to new_session_path
    else
      render :edit
    end
  end

  private

  def check_user_params # проверка на то есть ли вообще params[:user]
    redirect_to(new_session_path, flash: { warning: t('.fail') }) if params[:user].blank?
  end

  def set_user
    @user = User.find_by email: params[:user][:email], password_reset_token: params[:user][:password_reset_token]
    # params[:user][:email] и params[:user][:password_reset_token] - из URL экшена edit
    redirect_to(new_session_path, flash: { warning: t('.fail') }) unless @user&.password_reset_period_valid? # редиректим если такого пользователя нет или токен уже недействителен
    # @user&.password_reset_period_valid? - метод проверяет, действителен ли еще токен по времени его жизни, создадим этот метод в консерне concerns/recoverable.rb
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation).merge(admin_edit: true) # Разрешаем только :password и :password_confirmation
    # merge(admin_edit: true) - используем ранее(UserRoles) созданный атрибут, чтобы обойти проверку старого пароля из модели, можно назвать это как-то более универсально вместо admin_edit
  end
end


# 5. После того как пароль был сброшен, нужно очистить поля password_reset_token и password_reset_token_sent_at в БД, тк это у нас одноразовый токен. Для этого в консерне recoverable.rb создадим метод clear_reset_password_token и колбэк для его вызова (можно былоб вызывать и в экшене update но так удобнее)


# 6. Дополнительно можно разнести переводы писем на разные языки в разные представления (локализированные представления), тк если тема письма переводится в мэйлере password_reset_mailer.rb, но сам текст письма нет.
# локализированные представления - это представления, которые содержат код локали (ru, en) перед расширениями
# reset_email.en.html.erb и reset_email.ru.html.erb - для писем в формате html
# reset_email.en.text.erb и reset_email.ru.text.erb - для писем в формате text
# Эти локализированные представления автоматически подтянутся, в представлениях нужно только добавить локаль в ссылку, чтобы при переходе по ней язык остался тем же.


















#
