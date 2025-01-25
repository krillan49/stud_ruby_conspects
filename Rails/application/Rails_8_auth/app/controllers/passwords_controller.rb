class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  # new - отображает форму для запроса сброса пароля.
  def new
  end

  # create - обрабатывает запрос на сброс, отправляя электронное письмо с инструкциями по сбросу, если пользователь существует. Электронное письмо содержит ссылку с password_reset_token, которая по умолчанию истекает через 15 минут, предоставляя доступ к странице сброса пароля.
  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  # edit - показывает форму, в которой пользователь может ввести новый пароль.
  def edit
  end

  # update - завершает смену пароля, перенаправляя в случае успеха или отображая ошибку в случае неудачи.
  def update
    if @user.update(params.permit(:password, :password_confirmation))
      redirect_to new_session_path, notice: "Password has been reset."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private
    # set_user_by_token - before_action для edit и update, который идентифицирует пользователя на основе токена сброса в URL-адресе, обеспечивая безопасную обработку сброса.
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
