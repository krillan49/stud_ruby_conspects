puts '                                     API приоложения. Гем Faraday'

# API (application programming interface) - програмный интерфейс(а нажатие кнопочек это графический, это другое), который описывает то как с программой стоит взаимодействовать, те предоставляет способы/правила взаимодействия с программой(если мы пошлем такойто запрос на такойто URL, то сервер вернет нам такойто ответ). Те у каждого возможного действия есть то что ожидается на вход и есть то что ожидается на выходе.

# API например есть у многих других приложений, соцсетей, месеннджеров итд - позволяет без ручного ввода через браузер и сложного кастомного парсинга програмным способом запрашивать данные со страниц приложения (везде это все может быть устроено по разному, соотв нужно почитать документацию API с которым мы хотим взаимодействовать)

# Основная фича в том что мы заходим в приложение не через браузер руками, а через программу, соотв эту программу нужно идентифицировать, для этого в API соотв приложения обычно нужно сгенерировать специальный токен для входа через програаму

# Например в Twitter API функционал находится на странице твитер-девелопмент, на ней есть все что необходимо для разработчика, нужно зарегаться, создать новый проект, и в нем создать наше приложение, через которое чтото будем запрашивать из твитера, будем заходить в твитер через это приложение



# faraday    -  популярный гем для удобной работы с вебсайтами(HTTP/REST API client library), например отправка запросов на сторонние ресурсы. Более мощный чем встроенное решение Руби.
# https://rubygems.org/gems/faraday
# https://github.com/lostisland/faraday
# GEMFILE:
gem 'faraday', '~> 2.9'
# INSTALL:
# > gem install faraday



require 'faraday' # подключаем гем Faraday
require 'json'

token = 'kjhgfhgfyhgf78yfguylgJHGYFvtgJHGFHT' # токен для входа сгенереный необходимым API (естественно делиться им не надо)
url = 'https://api.twitter.com/2/users/1340584098075717635/tweets'  # адрес ресурса на который хотим обращаться
# api - значит что обращаемся к API, 2 - версия API, потом id юзера и его твиты(все что нужно писать в ссылке можно глячнуть в доках)

# Посылаем GET запрос протокола HTTP, через метод get гема Faraday
response = Faraday.get( # в переменную получим ответ от сервера
  url, # наш адрес
  {max_results: 12}, # max_results - опция Twitter API для задания колличества результатов, пристыкуется к URL '?max_results=12'
  { "Authorization" => "Bearer #{token}" }  # Передаем наш токен на вход по правилам Twitter API, в формате заголовков GET запроса
)

puts response.body.class #=> String    # те получаем строку отформатированную в формате JSON
puts response.body #=> строка
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

raw_tweets = JSON.parse(response.body) # Преобразуем строку в хэш при помощи библиотеки JSON
# Теперь мы можем легко оперировать данными из ответа на наш запрос
















#