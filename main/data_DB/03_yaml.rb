puts '                                              YAML'

# YAML  - (yet another markup language) формат хранения данных, вида ключ-значение. Проще чем JSON. Используется часто для хранения переводов, конфигурации и других не очень сложных и объемных данные.

# Расширения для фаилов YAML - .yml или .yaml
# Например тут будет фаил - 41_yaml.yml (описание синтаксиса там)

# https://1cloud.ru/help/docker/manual_yaml           Краткий мануал по YAML


puts
puts '                                           YAML в Руби'

# https://ruby-doc.org/stdlib-3.1.0/libdoc/yaml/rdoc/YAML.html

# Этот модуль предоставляет интерфейс Ruby для сериализации данных в YAMLформате. Модуль YAML является псевдонимом Psych, YAML движка Ruby.

# https://github.com/ruby/psych
# https://ruby-doc.org/stdlib-3.1.0/libdoc/psych/rdoc/Psych.html

# Psych — это анализатор и эмиттер YAML. Psych использует libyaml для своих возможностей анализа и генерации YAML. Помимо упаковки libyaml, Psych также знает, как сериализовать и десериализовать большинство объектов Ruby в формат YAML и из него.


puts
puts '                                      Считывание YAML в Руби'

require 'yaml' # чтобы считывать фаилы YAML в руби нужно подгрузить встроенный модуль


# safe_load_file - метод безопасного(не пускает хак-код) чтения, загружает YAML фаил, обрабатывает и преобразует в обычный хэш или массив(если ключи верхнего уровня - элементы массива) хэшей
data = YAML.safe_load_file('03_yaml/01_read.yml', symbolize_names: true)
# 03_yaml/01_read.yml     - относительный маршрут YAML фаила
# symbolize_names: true   - преобразует ключи в хэше в символы (по умолчанию ключи будут строками)

p data #=> {:key1=>"Value 1", :key2=>"Value 2", :hello=>"bye", :some=>{:some1=>"some", :some2=>"some2"}, :key3=>["K3value 1", "K3value 2", "K3value 3"]}
# Соотв далее можем пользоваться обычным хэшем с данными
p data[:key3] #=> ["K3value 1", "K3value 2", "K3value 3"]


# Ваариант вывода в виде массива из 2го примера в 41_yaml.yml
data = YAML.safe_load_file('03_yaml/02_read.yml', symbolize_names: true)
p data
#=> [
#      {:question=>"В какой стране придумали панамы?", :answers=>["Эквадор", "Панама", "Гондурас", "Канада"]},
#      {:question=>"Сколько лет длилась столетняя война?", :answers=>[116, 100, 101, 128]},
#      {:question=>"Что означает польское слово lustra?", :answers=>["Зеркало", "Люстра", "Стекло", "Ковёр"]}
# ]
p data[0][:question] #=> "В какой стране придумали панамы?"


puts
puts '                                       Вставки в YAML(?)'

# Фаил 03_yaml/03_insert.yml
# А вызов вот так:
Message.call(:you_are_looser, year: 2, month: 2, day: 1)
# первый аргумент это символ - ключ, остальные — хэш с параметрами. остается только заменить шаблоны в строке и готово


puts
puts '                                     Запись в YAML. Метод to_yaml'

# https://stackoverflow.com/questions/14532959/how-do-you-save-values-into-a-yaml-file

require 'yaml'


# 1. Если хотим изменить существующий yml фаил, то загружаем его и получаем от него хэш или массив и присваиваем в переменную
hh = YAML::load_file('03_yaml/04_write.yml')
p hh       #=> {"content"=>{"session"=>2, "session2"=>10}}
p hh.class #=> Hash
# Тоесть далее просто изменяем значения этого хэша(или массива) или добавляем новые как обычно
hh['content']['session'] = 5                     # изменяем значение существовавшего каталога под ключами content.session
hh['content']['session2'] = 10                   # добавляем новый подкаталок к существующему
hh['some'] = {'A' => [1, 2, 3]}                  # создаем новый каталог с подкаталогами
File.open('03_yaml/04_write.yml', 'w') do |file| # либо записываем так или любым удобным способом например
  # to_yaml - метод преобразует хэш или массив в строку формата yaml
  p hh.to_yaml            #=> "---\ncontent:\n  session: 5\n  session2: 10\nsome:\n  A:\n  - 1\n  - 2\n  - 3\n"
  p hh.to_yaml.class      #=> String
  file.write(hh.to_yaml)                         # теперь можем просто записать в фаил обычным способом
end


# 2. Если хотим создать новый yml фаил, то просто создаем новый хэш или массив с необходимой нам структурой и значениями, а потом преобразуем его в строку формата YAML и записываем в новый фаил
arr = [
  'ABC' => {'aaa' => 'AAA', 'bbb' => 'BBB', 'ccc' => 'CCC'},
  nums: [1, 2, 3, 4, 5]  # если задавать ключи символами, то они будут с двоеточием в начале каталога
]
File.write("03_yaml/05_write.yml", arr.to_yaml)











#
