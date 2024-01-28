puts '                      Отправка писем (ActionMailer, letter_opener) и сброс пароля'

# На примере AskIt. Создадим отдельный маршрут, контроллер и представление, где пользователь сможет(без входа на свой профиль, где он и так может все поменять, но например пользователь забыл свой пароль) ввести свой имэйл адрес и нажать кнопку "сбросить пароль", после отправки этой формы пользователю на почту придет уникальная ссылка, в ней будет зашит специальный защитный токен, после сброса данный токен становится невалидным, а у пользователя появляется новый пароль.


# 1. Создадим новый маршрут для контроллера сброса пароля в routes.rb
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    resource :password_reset, only: %i[new create edit update]
    # resource - создаем именно ресурс, а не ресурсы, тк ни с какими id работать не будем, а только с записью юзера по имэйл
    # new create - для того чтобы запросить у пользователя инструкции для сброса пароля
    # edit update - для того чтобы сбросить пароль
  end
end


# 2. Создадим диракторию для представлений сброса пароля /password_resets
# new.html.erb - создаем представление с формой, где можно запросить сброс пароля
# sessions/new.html.erb - добавим кнопку "забыл пароль" с которой и вызовется форма выше


# 3. В Рэилс уже есть базовый функционал, который позволяет отправлять почту:
# app/mailers/application_mailer.rb - базовый класс мэйлера от которого мы можем наследовать
class ApplicationMailer < ActionMailer::Base
  default from: 'admin@askit.com' # тут мы можем написать(изменить) от кого будут письма приходить (пофиг что ??)
  layout 'mailer' # тут указывается специальный лэйаут для писем
end

# Лэйауты находятся в директории лэйаутов(код там же) вместе с обычным лэйаутом:
# layouts/mailer.html.erb  - для письма в формате html
# layouts/mailer.text.erb  - для письма в формате плэйнткста
# Лэйаута 2 так как разные почтовые клиенты предпочитают разные форматы писем, поэтому всегда будет отправлено 2 письма обоих форматов

# Создадим новый мэйлер mailers/password_reset_mailer.rb, через который мы будем отправлять почту с данными по смене пароля
class PasswordResetMailer < ApplicationMailer # мэйлеры обычно именуются в единственном числе
  # Создадим метод при помощи которого будет отправляться почта(название любое)
  def reset_email
    @user = params[:user]
    # :user - сущность юзера в парамс устанавливаем при вызове данного метода из контроллера PasswordResetsController#create

    mail to: @user.email, subject: I18n.t('password_reset_mailer.reset_email.subject')
    # mail - метод отправляющий почту, может принимать много разных параметров
    # to: @user.email  - кому отправляем, тут на имэйл юзеру
    # subject: I18n.t('password_reset_mailer.reset_email.subject')   - тема письма
  end
end


# 4. Создадим контроллер password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_action :require_no_authentication # пароль можно сбрасывать только тем кто еще не вошел в систему (тк они и сами могут)

  # Экшен create тут будет отправлять инструкции для сброса пароля
  def create
    @user = User.find_by email: params[:email] # находим юзера по указанному пользователем в форме имэйлу

    if @user.present? # если юзер нашелся в БД
      # Вызываем метод reset_email мэйлера PasswordResetMailer для отправки почты:
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
      # user: @user - устанавливаем ключ и значение для params[:user] метода reset_email
      # deliver_later - отправить позже, поставит отправку письма в очередь и она произойдет уже в фоновом режиме(нужно настроить иначе будет тоже как и deliver_now). Желательно использовать его если отправляем письма из контроллера, если отправляем из самих фоновых задач, то уже бессмысленно
      # deliver_now - отправить сейчас, это значит пока письмо не уйдет метод будет постоянно пытаться кго отправить, соотв страница у пользователя будет грузиться и ему придется ждять, чтоб перейти на другую
    end
    flash[:success] = t '.success' # в любом случае саксесс, чтоб злоумышленники не угадывали пароли
    redirect_to new_session_path # на страницу логина
  end
end


# 5. Создадим собственно письмо, которое отправим. Для этого в представлениях создадим дирректорию /password_reset_mailer с представлениями, только представлениями не для контроллера, а для мэйлера, которые собственно и будут рендерить письма. Называем представления точно так же как и имя метода(reset_email) в мэйлере, который отправляет письмо, чтобы метод вызывал одноименное представление по умолчанию(суть такая же как и с именами экшенов контроллера):
# reset_email.html.erb  - для письма в формате html
# reset_email.text.erb  - для письма в формате text

# Это напотом для темы локализации:
# reset_email.en.html.erb и reset_email.ru.html.erb - для писем в формате html
# reset_email.en.text.erb и reset_email.ru.text.erb - для писем в формате text



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
# выше была, после нее добавим:
config.action_mailer.delivery_method = :letter_opener # те отправка писем будет производиться через данный гем(в environments/production.rb тут будет чето другое например SMTP)
config.action_mailer.perform_deliveries = true # тк по умолчанию в девелопмент среде письма не отправляются вовсе
config.action_mailer.default_url_options = { host: 'localhost:3000' } # адрес нашего хоста, нужен для того, чтобы генерировать полные URL адреса ссылок для перехода из нашего от письма в почтовом клиенте пользователя, например к активации сброса пароля


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
# SAMPLE HTML
# Так же в журнале событий в консоли будет вся информация, в том числе и код разметки с лэйаутами


puts
puts '                                    Токен для сброса пароля'

# Нам неоходимо сгенерировать специальный токен, с помощью которого мы сможем идентифицировато что это тот пользователь сбрасывает имэйл, который имеет на это право, а не какойнить злоумышленник

# Метод генерации будет запускаться в контроллере в экшене create, чтобы передать его в письме
class PasswordResetsController < ApplicationController
  before_action :require_no_authentication

  def create
    @user = User.find_by email: params[:email]

    if @user.present?
      @user.set_password_reset_token
      # set_password_reset_token - метод генерирует токен, название любое
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
    end

    flash[:success] = t '.success'
    redirect_to new_session_path
  end
end

















#
