module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization # Подключим Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized # обработка ошибки отсутствия прав на экшен

    private

    def user_not_authorized # обработка ошибки отсутствия прав на экшен
      flash[:danger] = t 'global.flash.not_authorized'
      redirect_to(request.referer || root_path) # редирект на страницу с которой переходили на ошибку или корневую
    end
  end
end
