module FunTranslations
  class Client
    include FunTranslations::Request # подключаем из lib/fun_translations/request.rb

    attr_accessor :token

    def initialize(token = nil)
      @token = token # необязательный токен авторизации для платной версии API, если юзер добавил его, для последующего проброса в заголовки запроса
    end

    # translate - метод к которому будет напрямую обращаться пользователь
    def translate(endpoint, text, params = {})
      # endpoint - значение типа перевода, например :yoda, для подстановки в адрес
      # text - текст который нужно перевести
      # params = {}  - дополнительные параметры, например :speed и :tone, если пользователь хочет получить аудио
      FunTranslations::Translation.new( # Translation.new - объект нашего класса, который примет хэш полученный от метода post ниже, вида: {"translated": "Force be with you my padawan!", "text": "Hello my padawan!",  "translation": "yoda" }
        post( "/translate/#{endpoint}.json", self, { text: text }.merge(params) )
        # post - наш метод из FunTranslations::Request
        # "/translate/#{endpoint}.json" - адрес для конкретного перевода для пристыковки к https://api.funtranslations.com
        # self - передаем сам этот экземпляр клиента, чтобы от него получить токен и положить его в заголовки запроса
        # { text: text } - добавляем текст в хэш тк faraday ожидает данные такого вида, чтоб отформатировать их в url_encoded
      )
    end
  end
end













#
