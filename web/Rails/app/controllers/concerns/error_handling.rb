module ErrorHandling
  extend ActiveSupport::Concern # делаем экстенд данного модуля ??

  included do # Теперь когда модуль ErrorHandling подключается в класс, то выполняется данный блок и данный код вставляется в класс там где подключем модуль
    rescue_from ActiveRecord::RecordNotFound, with: :notfound

    private

    def notfound(exception)
      logger.warn exception
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end
end
