module FunTranslations
  module Request
    include FunTranslations::Connection # подключаем модуль подключения lib/fun_translations/connection.rb

    def post(path, params = {}) # создаем на метод пост-запроса
      # path --> translate/yoda.json
      # params = { text: "Hello my padawan!" }
      connection.post(path, params) # тут метод Фарадея от метода connection из lib/fun_translations/connection.rb
    end
  end
end
