module FunTranslations
  module Request
    include FunTranslations::Connection # подключаем модуль подключения lib/fun_translations/connection.rb

    def post(path, params = {}) # создаем метод пост-запроса нашего гема
      # path --> translate/yoda.json
      # params = { text: "Hello my padawan!" }  # тк faraday ожидает данные такого вида, чтоб отформатировать их в url_encoded
      respond_with(
        # respond_with - наш метод ниже для парсинга JSON-ответа в хэш
        connection(client).post(path, params) #=> JSON-ответ от API
        # connection - метод из lib/fun_translations/connection.rb
        # post - метод Фарадея для отправки пост запроса
      )
    end

    private

    def respond_with(raw_response)
      # raw_response.status HTTP 2xx 3xx 404 500
      # raw_response.success?

      # Получим тело ответа при помощи метода body гема faraday
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

      # respond_with_error(raw_response.status, body) if !raw_response.success?

      body['contents'] # вернем только контент из хэша
    end

    def respond_with_error(code, body)
      # ...
    end
  end
end














#
