class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  # new - представляет форму входа для учетных данных пользователя. new.html.erb предлагает поля для электронной почты и пароля пользователя, флэш-сообщения об ошибках или успехе и ссылку для сброса пароля при необходимости.
  def new
  end

  # create - аутентифицирует пользователя на основе предоставленных учетных данных. После успешного входа он начинает сессию и перенаправляет на after_authentication_url; если учетные данные неверны, он перенаправляет на форму входа с сообщением об ошибке.
  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  # destroy - завершает текущую сессию и возвращает пользователя на страницу входа.
  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
