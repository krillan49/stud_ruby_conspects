module Authentication
  extend ActiveSupport::Concern

  included do

    private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present?
    end
    # модифицируем метод и под куки
    def current_user
      if session[:user_id].present? # сперва прверяем в сессии
        @current_user ||= User.find_by(id: session[:user_id]).decorate
      elsif cookies.encrypted[:user_id].present? # если нет в сессии то проверяем в куки
        user = User.find_by(id: cookies.encrypted[:user_id]) # получаем юзера по айди взятому из куки
        if user&.remember_token_authenticated?(cookies.encrypted[:remember_token]) # используем метод проверки из модели и сравниваем токен из куки с хэшированным токеном этого пользователя из БД
          sign_in(user) # если все сходится можно и сразу установить сессиию, чтобы ускорить послед проверки
          @current_user ||= user&.decorate # и если все сходится назначаем текущего пользователя
        end
      end
    end
    # отрефакторим выделив подметоды по рекомендации рубокопа
    def current_user
      user = session[:user_id].present? ? user_from_session : user_from_token
      @current_user ||= user&.decorate
    end
    def user_from_session
      User.find_by(id: session[:user_id])
    end
    def user_from_token
      user = User.find_by(id: cookies.encrypted[:user_id])
      token = cookies.encrypted[:remember_token]
      return unless user&.remember_token_authenticated?(token)
      sign_in user
      user
    end

    def user_signed_in?
      current_user.present?
    end

    def sign_in(user) # метод для создания сессии
      session[:user_id] = user.id
    end

    def remember(user) # метод запоминания пользователя в куки
      user.remember_me # применяем метод из модели User заполняющий колонку remember_token_digest хэшем токена
      cookies.encrypted.permanent[:remember_token] = user.remember_token # помещаем remember_token (не хэшированныый), который сгенерили в методе remember_me, в куки браузера пользователя, под ключем :remember_token
      # permanent - необязательный метод, делающий куки практически вечным(тк по умолчанию срок действия куки истекает), но при желании можно поставить свой срок истечения https://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
      # encrypted - необязательный метод шифрующий куки(от пользователя), будет расшифровано автоматически на сервере
      cookies.encrypted.permanent[:user_id] = user.id # поместим в куки и юзерайди, удобно для определения пользователя
    end

    def forget(user) # метод забывания/удаления токена и айди юзера из куки
      user.forget_me # применяем метод из модели User удаляющий из колонки remember_token_digest хэш токена
      cookies.delete :user_id
      cookies.delete :remember_token
    end

    def sign_out # метод для удаления сессии
      forget(current_user) # заодно удалим куки(можно либо тут либо в экшене sessions#destroy)
      session.delete :user_id
      @current_user = nil
    end

    def require_authentication # доступ только для тех кто уже есть в системе
      return if user_signed_in? # выходим до кода ограничений если пользователь в системе
      flash[:warning] = "You are not signed in!"
      redirect_to root_path
    end

    def require_no_authentication # доступ только для тех кого еще нет в системе
      return unless user_signed_in? # если пользователь не в системе, то код далее с ограничением не исполняется
      # а если пользователь уже есть в системе, то редиректим на главную, тк регистрировапться/входить нет смысла
      flash[:warning] = "You are already signed in!"
      redirect_to root_path
    end

    helper_method :current_user, :user_signed_in?
  end
end















#
