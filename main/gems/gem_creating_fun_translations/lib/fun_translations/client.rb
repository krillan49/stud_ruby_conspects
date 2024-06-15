module FunTranslations
  class Client
    include FunTranslations::Request # подключаем из lib/fun_translations/request.rb

    attr_accessor :token

    def initialize(token = nil)
      @token = token
    end

    # translate - метод к которому будет напрямую обращаться пользователь
    def translate(endpoint, text, params = {})
      # endpoint - значение типа перевода, например :yoda, для подстановки в адрес
      # text - текст который нужно перевести
      FunTranslations::Translation.new( # Translation.new - объект нашего класса, который примет хэш полученный от метода post ниже, вида: {"translated": "Force be with you my padawan!", "text": "Hello my padawan!",  "translation": "yoda" }
        post( "/translate/#{endpoint}.json", self, { text: text }.merge(params) )
        # post - наш метод из FunTranslations::Request
        # "/translate/#{endpoint}.json" - адрес для конкретного перевода для пристыковки к https://api.funtranslations.com
        # { text: text } - добавляем текст в хэш тк faraday ожидает данные такого вида, чтоб отформатировать их в url_encoded
      )
    end
  end
end













#
