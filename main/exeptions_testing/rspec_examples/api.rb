require 'faraday'

def translate(type, text)
  # При запросе его перехватит Webmock
  conn = Faraday.new url: 'https://api.funtranslations.com' # Создаем экземпляр Фарадей с передачей базового URL
  res = conn.post("/translate/#{type}.json", "text=#{text}") # Посылаем пост-запрос
  JSON.parse(res.body)
end
