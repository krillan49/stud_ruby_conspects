puts '                                             Std-lib json'

# json - стандартная библиотека Руби для парсинга JSON

# Есть замена для библиотеки JSON - это гем Oj(сторонняя библиотека быстрее чем JSON)


require 'json' # подключаем стандартную библиотеку json


# json-строка в виде Руи строки
json_string = '{"data":
  [
    {"id":"15", "text":"21.08\nРыбы: могут рождаться дети"},
    {"id":"16", "text":"21.08\nВодолей: лучше не спать"}
  ]
}'

# Такуюже строку вернет и json-фаил (на всякий добавим кодировку)
json_string2 = File.read('./json/some.json', encoding: 'utf-8')
p json_string2
#=> "{\"data\":\n  [\n    {\"id\":\"15\", \"text\":\"21.08\\nРыбы: могут рождаться дети\"},\n    {\"id\":\"16\", \"text\":\"21.08\\nВодолей: лучше не спать\"}\n  ]\n}\n"


# parse - метод преобразует строку содержащую JSON(например ответ на GET запрос будет в формате строки) в хэш, который мы уже сможем удобно использовать
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
