module FunTranslations
  module Request
    include FunTranslations::Connection # подключаем модуль подключения lib/fun_translations/connection.rb

    def post(path, client, params = {}) # создаем метод пост-запроса нашего гема
      # path   #=> 'translate/yoda.json'
      # client - экземпляр клиента, чтобы пробросить его в connection и добавить токен в заголовки запроса
      # params #=> { text: "Hello my padawan!" }  # тк Faraday ожидает данные такого вида, чтоб отформатировать их в url_encoded
      respond_with( # respond_with - наш метод ниже для парсинга JSON-ответа от API в хэш
        connection(client).post(path, params) #=> JSON-ответ от API
        # connection - метод из lib/fun_translations/connection.rb с экземпляром подключения Faraday
        # post - метод Faraday для отправки пост запроса, вернет JSON-ответ от API
      )
    end

    private

    def respond_with(raw_response)
      # Получим тело ответа при помощи метода body гема Faraday
      body = raw_response.body.empty? ? raw_response.body : JSON.parse(raw_response.body)
      # JSON.parse(raw_response.body) - если тело ответа не пустое распарсим JSON в хэш
      # {
      #     "success": { "total": 1 },
      #     "contents": {
      #         "translated": "Force be with you my padawan!",
      #         "text": "Hello my padawan!",
      #         "translation": "yoda"
      #     }
      # }

      # Создадим метод порождения исключений и обработок ошибок, если Фарадей выявил ошибку ответа (например 404)
      respond_with_error(raw_response.status, body['error']) if !raw_response.success?
      # Принимает код состояния(например 404) и тело ошибки(хэш)

      body['contents'] # вернем только раздел контента из хэша
    end

    def respond_with_error(code, body) # принимает код состояния HTTP(например 404) и тело ответа(тут с сообщением об ошибке)
      # вызовем нашу материнскую ошибку, если в хэше констант не учтен данный код ошибки
      raise(FunTranslations::Error.from_response(body)) unless FunTranslations::Error::ERRORS.key?(code)
      # вызовем конкретную ошибку по ее константе из хэша и вызовем метод from_response соответсвующего класса из error.rb
      raise FunTranslations::Error::ERRORS[code].from_response(body)
    end
  end
end














#
