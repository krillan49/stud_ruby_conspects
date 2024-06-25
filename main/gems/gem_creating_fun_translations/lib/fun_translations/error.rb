module FunTranslations
  class Error < StandardError
    # Подраделим на подклассы-наследники Error:
    ClientError = Class.new(self) # ошибки клиента, например отправленно слишком много запросов
    ServerError = Class.new(self) # ошибки сервера

    # Подклассы-наследники ClientError для клиентских ошибок
    BadRequest = Class.new(ClientError)
    Unauthorized = Class.new(ClientError)
    NotAcceptable = Class.new(ClientError)
    NotFound = Class.new(ClientError)
    Conflict = Class.new(ClientError)
    TooManyRequests = Class.new(ClientError)
    Forbidden = Class.new(ClientError)
    Locked = Class.new(ClientError)
    MethodNotAllowed = Class.new(ClientError)

    # Подклассы-наследники ServerError для серверных ошибок
    NotImplemented = Class.new(ServerError)
    BadGateway = Class.new(ServerError)
    ServiceUnavailable = Class.new(ServerError)
    GatewayTimeout = Class.new(ServerError)

    # Хэш для вызова исключения по его соответсвию коду ошибки
    ERRORS = {
      400 => FunTranslations::Error::BadRequest,
      401 => FunTranslations::Error::Unauthorized,
      403 => FunTranslations::Error::Forbidden,
      404 => FunTranslations::Error::NotFound,
      405 => FunTranslations::Error::MethodNotAllowed,
      406 => FunTranslations::Error::NotAcceptable,
      409 => FunTranslations::Error::Conflict,
      423 => FunTranslations::Error::Locked,
      429 => FunTranslations::Error::TooManyRequests,
      500 => FunTranslations::Error::ServerError,
      502 => FunTranslations::Error::BadGateway,
      503 => FunTranslations::Error::ServiceUnavailable,
      504 => FunTranslations::Error::GatewayTimeout
    }.freeze

    # Метод класса истанцирующий ошибку этого класса
    def self.from_response(body)
      msg = body['detail'] || body['message'] # обычно в ответах от сервера сообщение лежит под такими ключами
      new msg.to_s # порождает исключение текущего класса, от константы которого вызван метод 'from_response', тк 'new' это метод класса, соотв у нас получается self.new или Error::BadRequest.new в который передаем дополнительно текстовое сообщение
    end
  end
end










#
