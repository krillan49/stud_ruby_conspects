require 'faraday'

def translate()
  conn = Faraday.new url: 'https://api.funtranslations.com' # Создаем экземпляр Фарадей с передачей базового URL
  res = conn.post('/translate/yoda.json', "text=Master Obiwan has lost a planet.") # Посылаем пост-запрос
  JSON.parse(res.body)
end
