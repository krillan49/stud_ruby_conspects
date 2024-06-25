module FunTranslations
  module Connection
    BASE_URL = 'https://api.funtranslations.com' # вынесем в константу базовый URL используемого API

    def connection(client)
      # client - объект класса Client, который далее пробросим в options и добавим из него токен в заголовки
      Faraday.new( options(client) ) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.request :url_encoded
      end
    end

    private

    def options(client)
      headers = {
        accept: 'application/json',
        'Content-Type' => 'application/x-www-form-urlencoded',
        user_agent: "fun_translations gem/#{FunTranslations::VERSION}"
      }
      headers['X-Funtranslations-Api-Secret'] = client.token unless client.token.nil? # добавляем необязательный токен авторизации для платной версии API, если юзер добавил его при создании клиента
      {
        headers: headers,
        url: BASE_URL
      }
    end
  end
end











#
