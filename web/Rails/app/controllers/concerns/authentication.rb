module Authentication
  extend ActiveSupport::Concern

  included do
    # код из application_controller.rb
    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
    end

    def user_signed_in?
      current_user.present?
    end

    def sign_in(user) # метод для создания сессии
      session[:user_id] = user.id
    end

    def sign_out # метод для удаления сессии
      session.delete :user_id
      @current_user = nil
    end

    def require_authentication # тоесть доступ только для тех кто уже есть в системе
      return if user_signed_in? # тоесть выходим до кода ограничений если пользователь в системе
      flash[:warning] = "You are not signed in!"
      redirect_to root_path
    end

    def require_no_authentication # тоесть доступ только для тех кого еще нет в системе
      return unless user_signed_in? # тоесть если пользователь не в системе, то код далее с ограничением не исполняется
      # а если пользователь уже есть в системе, то редиректим на главную, говоря ему что он уже в системе и регистрировапться/входить нет смысла
      flash[:warning] = "You are already signed in!"
      redirect_to root_path
    end

    helper_method :current_user, :user_signed_in?
  end
end















#
