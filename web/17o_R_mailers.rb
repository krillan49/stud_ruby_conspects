puts '                      Отправка писем (ActionMailer, letter_opener) и сброс пароля'

# На примере AskIt. Создадим отдельный маршрут, контроллер и представление, где пользователь сможет(без входа на свой профиль, где он и так может все поменять, но например пользователь забыл свой пароль) ввести свой имэйл адрес и нажать кнопку "сбросить пароль", после отправки этой формы пользователю придет уникальная ссылка, в ней будет зашит специальный защитный токен, после сброса данный токен становится невалидным, а у пользователя появляется новый пароль.


# 1. Создадим новый маршрут для контроллера сброса пароля в routes.rb
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    resource :password_reset, only: %i[new create edit update]
    # resource - создаем именно ресурс, а не ресурсы, тк ни с какими id работать не будем, а только с 1й записью юзера по имэйл
    # new create - для того чтобы запросить у пользователя инструкции для сброса пароля
    # edit update - для того чтобы сбросить пароль
  end
end


# 2. Создадим диракторию для представлений сброса пароля password_resets
# new.html.erb - создаем представление с формой, где можно запросить сброс пароля
# sessions/new.html.erb - добавим кнопку "забыл пароль" с которой и вызовется форма выше


# 3. В Рэилс уже есть базовый функционал, который позволяет отправлять почту:
# app/mailers/application_mailer.rb - базовый класс мэйлера от которого мы можем наследовать
class ApplicationMailer < ActionMailer::Base
  default from: 'admin@askit.com' # тут мы можем написать(изменить) от кого будут письма приходить (повиг что ??)
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
    # :user - юзера в парамс устанавливаем при вызове данного метода из контроллера PasswordResetsController#create

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
  #   @user = User.find_by email: params[:email]
  #
  #   if @user.present?
  #     @user.set_password_reset_token

      # Вызываем метод reset_email мэйлера PasswordResetMailer для отправки почты:
      PasswordResetMailer.with(user: @user).reset_email.deliver_later
      # user: @user - устанавливаем ключ и значение для params[:user] метода reset_email
      # deliver_later - отправить позже, поставит отправку письма в очередь и она произойдет уже в фоновом режиме(нужно настроить иначе будет тоже как и deliver_now). Желательно использовать его если отправляем письма из контроллера, если отправляем из самих фоновых задач, то уже бессмысленно
      # deliver_now - отправить сейчас, это значит пока письмо не уйдет метод будет постоянно пытаться кго отправить, соотв страница у пользователя будет грузиться и ему придется ждять, чтоб перейти на другую

  #   end
  #
  #   flash[:success] = t '.success'
  #   redirect_to new_session_path
  end
end




















#
