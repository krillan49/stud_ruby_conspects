puts '                                             JSON'

# https://ru.wikipedia.org/wiki/JSON

# JSON (application/json) - (JS Object Notationд) универсальный формат хранения данных(по сути большой хэш или строка отформатированная как хэш ??). Лучше например того формата что мы придумали для локалсторедж в пицашоп, тк там пришлось для него писать парсер, а тут они уже написаны.

# Пример JSON-представление объекта, описывающего человека. В объекте есть строковые поля имени и фамилии, объект, описывающий адрес и массив, содержащий список телефонов. Значение может представлять собой вложенную структуру.
'{
  "firstName": "Иван",
  "lastName": "Иванов",
  "address": {
    "streetAddress": "Московское ш., 101, кв.101",
    "city": "Ленинград",
    "postalCode": 101101
  },
  "phoneNumbers": [
    "812 123-1234",
    "916 123-4567"
  ]
}'



puts '                                             Std-lib json'

# json - стандартная библиотека Руби для работы с JSON

# Есть замена для библиотеки JSON - это гем Oj(сторонняя библиотека быстрее чем JSON)

require 'json' # подключаем стандартную библиотеку json

# Парсинг - обращение к веб странице и поиск на ней нужных нам элементов.

# parse - метод преобразует строку содержащую JSON(например ответ на GET запрос будет в формате строки) в хэш, который мы уже сможем удобно использовать
json_string = '{"data":
  [
    {"id":"15", "text":"21.08\nРыбы: могут рождаться дети"},
    {"id":"16", "text":"21.08\nВодолей: лучше не спать"}
  ]
}'
p JSON.parse(json_string)
#=> {"data"=>[{"id"=>"15", "text"=>"21.08\nРыбы: могут рождаться дети"}, {"id"=>"16", "text"=>"21.08\nВодолей: лучше не спать"}]}
p JSON.parse(json_string).class #=> Hash


# dump - метод преобразует хэш в JSON-строку
data = {
  success: {total: 1},
  contents: {
    translated: 'A planet, master Obi Wan lost',
    text: 'Master Obi Wan lost a planet',
    translation: 'yoda'
  }
}
p JSON.dump(data)
#=> "{\"success\":{\"total\":1},\"contents\":{\"translated\":\"A planet, master Obi Wan lost\",\"text\":\"Master Obi Wan lost a planet\",\"translation\":\"yoda\"}}"
















#
