module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user
    # Добавлено в helper_method: current_user
  end

  class_methods do
    # allow_unauthenticated_access - позволяет выполнить определенные действия для обхода require_authentication проверки. Те разрешает доступ без аутентификации, по умолчанию для всех экшенов. Надо добавить этот метод в контроллер. При переходе на экшен который не указан(если выбраны разрешенные) вернет страницу регистрации
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    # ============ кастомные методы ================
    def current_user
      @current_user ||= User.find_by(id: cookies.signed[:user_id]) if cookies.signed[:user_id]
    end
    # start_new_session_for(user) - в этот метод добавим сохранение :user_id в сессию
    # terminate_session - в этот метод добавим удаление :user_id из куки
    # ==============================================


    # authenticated? - проверяет, есть ли активная сессия для текущего пользователя.
    def authenticated?
      resume_session
    end

    # require_authentication - это before_action, который проверяет наличие существующей сессии с помощью resume_session. Если ничего не найдено, он перенаправляет пользователя на страницу входа через request_authentication
    def require_authentication
      resume_session || request_authentication
    end

    # resume_session - находит существующую сессию через подписанный токен cookie и устанавливает его как активную сессию. Затем он сохраняет этот токен сессии в постоянном HTTP-куки с set_current_session
    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    # start_new_session_for(user) - начинает новый сессия для указанного пользователя, записывая информацию об устройстве и IP-адресе пользователя.
    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }

        # Добавим строку для того чтобы сохранить айди юзера в куки сессии и применять его в методе current_user
        cookies.signed.permanent[:user_id] = { value: user.id, httponly: true, same_site: :lax }
      end
    end

    # terminate_session - завершает текущий сессия и удаляет его токен cookie.
    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)

      # Добавим строку для того чтобы удалять айди юзера(для current_user) из куки когда сессия завершена
      cookies.delete(:user_id)
    end
end
















#
