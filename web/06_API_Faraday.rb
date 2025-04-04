puts '                                             Faraday'

# https://rubygems.org/gems/faraday
# https://github.com/lostisland/faraday

# faraday   - (HTTP/REST API client library) гем для удобной работы с вебсайтами, например отправка запросов и работа с API. Более мощный чем встроенное решение Руби.

# Gemfile:
gem 'faraday', '~> 2.9'

# Обычная установка:
# > gem install faraday



puts '                                GET запрос, при помощи Faraday на API'

# Пошлем GET запрос на Twitter API

require 'faraday' # подключаем гем Faraday
require 'json'    # чтобы распарсить ответ

token = 'kjhgfhgfyhgf78yfguylgJHGYFvtgJHGFHT' # токен для входа сгенереный необходимым API (естественно делиться им не надо)
url = 'https://api.twitter.com/2/users/1340584098075717635/tweets'  # адрес ресурса на который хотим обращаться
# api - значит что обращаемся к API, 2 - версия API, потом id юзера и его твиты(все что нужно писать в ссылке есть в доках)

# Посылаем GET запрос протокола HTTP, через метод get гема Faraday
response = Faraday.get( # в переменную получим ответ от сервера
  url, # наш адрес
  { max_results: 12 }, # max_results - опция Twitter API для задания колличества результатов, пристыкуется к URL '?max_results=12'
  { "Authorization" => "Bearer #{token}" }  # Передаем наш токен на вход по правилам Twitter API, в формате заголовков GET запроса
)

puts response.body.class #=> String    # те получаем строку отформатированную в формате JSON
puts response.body
#=>
# {"data":
#   [
#     {"id":"1561218928298364929",
#     "text":"21.08\nРыбы: Сегодня у вас могут рождаться дети разных национальностей. ... "},
#     {"id":"1561218901652000768",
#     "text":"21.08\nВодолей: Сегодня лучше не спать в компании людей с длинными шеями. ..."},
#        ....
#   ],
# }

# Так же от объекта ответа можно получить статус код состояния HTTP, который возвращает сервер (2xx 3xx 404 500)
puts response.status   #=> 200
# Метод Фарадея который возвращает true если ответ без ошибок(например 200) и false если ошибка(например 404)
puts response.success? #=> true

raw_tweets = JSON.parse(response.body) # Преобразуем строку JSON в хэш, чтобы можно было легко оперировать данными



puts '                                POST запрос, при помощи Faraday на API'

# Пошлем POST-запрос на API https://api.funtranslations.com/, чтобы получить смешной перевод в стиле Мастера Йоды
require 'faraday'

# Создаем экземпляр Фарадей с передачей базового URL
conn = Faraday.new url: 'https://api.funtranslations.com'
# 'https://api.funtranslations.com' - базовый URL для запросов на api.funtranslations, к нему будем пристыковывать доп подадрес для конкретного перевода и параметры

# Посылаем пост-запрос при помощи метода post
res = conn.post('/translate/yoda.json', "text=Master Obiwan has lost a planet.")
# '/translate/yoda.json' - тоесть доп часть адреса к переводам Йоды на api.funtranslations.com
# "text=Master Obiwan has lost a planet." - параметры с текстом для перевода, которые будут пристыкованы к URL, тут заданы в стиле форматирования url_encoded

puts res.status   #=> 200
puts res.success? #=> true
puts res.body     #=>
# {
#     "success": {
#         "total": 1
#     },
#     "contents": {
#         "translated": "Lost a planet,  master obiwan has.",
#         "text": "Master Obiwan has lost a planet.",
#         "translation": "yoda"
#     }
# }

res_hh = JSON.parse(res.body) # Преобразуем строку JSON ответа(funtranslations тоже возвращает строку отворматированную как хэш) в хэш при помощи библиотеки JSON


puts
# Тот же запрос но в более подробной и сложной форме
require 'faraday'

# опции с указанием дополнительной информацией о запросе. Эти типы информации передаются например когда мы делаем запрос в ручную через браузер (их можно посмотреть в консоли разработчика: Network -> Тыкаем на строку какого либо запроса -> Headers -> Request Headers)
options = {
  # добавим заголовки запроса
  headers: {
    accept: 'application/json', # формат в котором мы хотим получить ответ от сервера (тут json)
    'Content-Type' => 'application/x-www-form-urlencoded', # формат в котором будем данные отправлять
    user_agent: "ruby program" # говорит о том что посылает запрос, например при ручном запросе через браузер тут будет тип браузера и операционной системы
  },
  url: 'https://api.funtranslations.com' # URL на который пошлем запрос
}

connection = Faraday.new(options) do |faraday|
  faraday.adapter Faraday.default_adapter # указываем какой адаптер использовать(у Фарадей есть разные)
  faraday.request :url_encoded # задаем стиль форматирования url_encoded для параметров, теперь когда метод post передаст хэш, например text: "Hello my padawan!", он будет отформатирован в строку "text=Hello my padawan!"
end

params = { text: "Hello my padawan!" } # перезаем парамаетры в виде хэша, который будет отформатирован в строку url_encoded

res = connection.post('translate/yoda.json', params) # Посылаем пост-запрос при помощи метода post

puts res.body #=>
# {
#     "success": {
#         "total": 1
#     },
#     "contents": {
#         "translated": "Force be with you my padawan!",
#         "text": "Hello my padawan!",
#         "translation": "yoda"
#     }
# }
















#
