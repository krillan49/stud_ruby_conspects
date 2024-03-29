puts '                                     Hash/хэшы(Ассоциативные массивы)'

# !!!deep_dup контринтуитивный момент для хэшей(как в случае с массивами) потом погуглить!!!

# В общем контексте вычислений хэш-функция принимает строку (или файл) любого размера и генерирует строку или целое число фиксированного размера, называемое хэш-кодом, обычно называемое просто хешем. Некоторые часто используемые типы хэш-кодов: MD5, SHA-1 и CRC. Они используются в алгоритмах шифрования, индексации баз данных, проверке целостности файлов и т. д.
# Некоторые языки программирования, такие как Ruby, предоставляют тип коллекции, называемый хеш-таблицей. Хэш-таблицы представляют собой коллекции, подобные словарям, в которых данные хранятся парами, состоящими из уникальных ключей и соответствующих им значений. Под капотом эти ключи хранятся в виде хэш-кодов. Хэш-таблицы обычно называют просто хэшами.
# В Ruby, когда мы сохраняем что-то в хеше (коллекции), объект, предоставленный как ключ (например, строка или символ), преобразуется и сохраняется как хеш-код. Позже, извлекая элемент из хеша (коллекции), мы предоставляем объект в качестве ключа, который преобразуется в хэш-код и сравнивается с существующими ключами. Если есть совпадение, возвращается значение соответствующего элемента. Сравнение производится с помощью команды eql? метод под капотом.

# Key value storage - ключ значение хранилище(Так иногда называют хэши). В некоторых языках хэши называют Dictionary(словарь).
# Элемент хэша это ключ и значение, а не просто значение как в array
# Ключи выполняют функцию аналогичную индексам в array, но не обязательно сохраняют порядок. Ключ должен быть уникальным
# В ассоциативных массивах в качестве ключей могут выступать: числа, переменные, строки, символы, другие асс массивы итд. Все имеющиеся в руби типы данных могут быть как ключами, так и значениями в ассоциативных массивах (хэшах – Hash).
# Если в array могут быть индексы без значений автоматически заполненные nil, то в hash такого нет, тк ключи не имеют порядка. Примечание: несмотря на то, что структура данных “хеш” не гарантирует порядок, в руби порядок гарантируется (однако, авторы бы не рекомендовали на него надеяться)
# В случае поиска элемента в массиве нужно просматривать весь массив(linear time, O(N)), а в случае поиска какого-либо объекта в хеше поиск происходит моментально(constant time, O(1))
# в новых версиях языка руби хеш, который содержит не более 7 элементов реализован через массив.

# Если попытаться получить доступ к хешу с помощью несуществующего ключа, метод вернет nil
# использовать переменную с названием “hash” нельзя, т.к. это зарезервированное ключевое слово языка

# Синтаксис:
some = { # Конструкция ассоциативного массива
	"Ключ1(Key1)" => "Значение1(Value1)", # Обязательно ставить запятую после каждого элемента
  # Символ => называется - Hash rocket(Устаревший символ)
	Key2: 'Значение2(Value2)', # Современный вид с двоеточием вместо рокета.
	'Ключ3(Key3)': 'Значение3(Value3)', # 'Ключ3(Key3)':  - это будет символ(:'Ключ1(Key1)') а не стринг Если ключ не задается кавычками и его синтаксис соответствует он автоматически становится symbol, соответсвенно numeric нельзя обозначить двоеточием как ключ.
  "RU" => 2.5,   # ключ String
  1 => "Жопа",   # ключ Integer (FixNum)
  UA: "pisya"    # ключ :UA - Symbol
}
# Двоеточие и рокет могут использоваться для разных ключей в одном хэше

some          #=> {"Ключ1(Key1)"=>"Значение1(Value1)", :Key2=>"Значение2(Value2)", :"Ключ3(Key3)"=>"Значение3(Value3)", "RU"=>2.5, 1=>"Жопа", :UA=>"pisya"}
some["RU"]    #=> 2.5
some[1]       #=> Жопа
some[:UA]     #=> pisya


# Хэши часто используются как параметры(font_size - размер шрифта. font_family - имя шрифта)
options = {:font_size => 10, :font_family => 'Arial', :arr => [1, 5, 2]}
puts "Selected font size #{options[:font_size]}" #=> "Selected font size 10"


puts
# Новый пустой хэш(Инициализация 1)
student_marks = Hash.new('aaa') # Можно указать значение по умолчанию ('aaa'), если не указать оно будет равно nil
student_marks[7] #=> "aaa"   # если ключ или значение не существует, вернет значение по умолчанию
student_marks['Literature'] = 74 # hash_name[key] = value (Задаем элементы хэша)
student_marks['Science'] = 89
student_marks.store('Math', 91) # store метод тоже для добавления значений в хэш
student_marks #=> {"Literature"=>74, "Science"=>89, "Math"=>91}

# Либо(Инициализация 2)
notebook = {}  # хз как доавить тут значение по умолчанию
notebook["Vasya"] = 34567
notebook["Petya"] = 56789
notebook #=> {"Vasya"=>34567, "Petya"=>56789}
# Присвоение нового значения
notebook["Vasya"] = 1 #=> {"Vasya"=>1, "Petya"=>56789}

# Еще один вариант инициализации
рр = Hash["a" => 100, "b" => 200]


# Hashvalue можно не указывать, это означает, что значение будет извлечено из контекста по имени ключа:
x = 0
y = 100
h = {x:, y:}
h # => {:x=>0, :y=>100}


# Инициализация хэша из 2d массивf
a = [0, 1, 2, 3, 4]
b = [:zero, :one, :two, :three, :four]
hash1 = Hash[a.zip(b)] #=> {0=>:zero, 1=>:one, 2=>:two, 3=>:three, 4=>:four}
hash2 = Hash[b.zip(a)] #=> {:zero=>0, :one=>1, :two=>2, :three=>3, :four=>4}


# Добавление/изменение элементов в массивы-элементы хэша
dict = {
	'cat' => ['кошка', 'кот', 'кашара'],
	'dog' => ['собака'],
	'girl' => ['девушка', 'девочка']
}
dict['dog'] << 1 #=> {"cat"=>["кошка", "кот", 'кашара'], "dog"=>["собака", 1], "girl"=>["девушка", "девочка"]}
dict['cat'][2] = :kity #=> {"cat"=>["кошка", "кот", :kity], "dog"=>["собака", 1], "girl"=>["девушка", "девочка"]}

# Удаление. Тк элемент хэша это ключ+значение, то и удалить их можно только вместе, а по отдельности только заменить
dict.delete('cat')
dict #=> {"dog"=>["собака", 1], "girl"=>["девушка", "девочка"]}


puts
puts '                                        Установка значения по-умолчанию'

# Иногда полезно устанавливать значения в хеше по-умолчанию
hh0 = Hash.new(0) # Параметр (0) это значение по умолчанию(говорит языку руби о том, что если ключ не найден, то вместо nil будет возвращено автоматическое значение по умолчанию(тут ноль))

# Установка значения по умолчанию уже существующему хэшу
hh00 = {a: 'b'}
hh00.default = 0
hh00[:b] #=> 0


# Например есть какое-то предложение, необходимо посчитать сколько раз встречается каждое слово.
str = 'the quick brown fox jumps over the lazy dog'
arr = str.split(' ') # Разобьем ее на массив слов.

# обойдем этот массив и занесем каждое значение в хеш, где ключом будет слово, а значением - количество повторов этого слова
hh = {}
arr.each do |word|
  if hh[word].nil? # нужно проверить: встречается ли слово в хеше
    hh[word] = 1 # Если не встречается, то добавить новое слово(key) и начальное колличество = 1(value).
  else
    hh[word] += 1 # Если встречается, то увеличить счетчик на 1
  end
end
hh.inspect #=> {"the"=>2, "quick"=>1, "brown"=>1, "fox"=>1, "jumps"=>1, "over"=>1, "lazy"=>1, "dog"=>1}

# Но эту программу можно было бы значительно облегчить, если знать, что в хеше можно установить значение по-умолчанию:
hh = Hash.new(0) # Параметр (0) это значение по умолчанию(говорит языку руби о том, что если слово не найдено, то вместо nil будет возвращено автоматическое значение - ноль)
arr.each do |word|
	# теперь нам не нужно проверять на nil и отдельно задавать новый ключ и начальное значение.
  hh[word] += 1 # тк оно автоматически теперь изначально равно 0
end
hh.inspect #=> {"the"=>2, "quick"=>1, "brown"=>1, "fox"=>1, "jumps"=>1, "over"=>1, "lazy"=>1, "dog"=>1}


# Удобно использовать и в предварительно созданных хэшах с существующими ключамию Тепрь при операции со значением по несуществующему ключу будет использоваться значение по умолчанию(тут -30)
ACTION_SCORES = Hash.new(-30).update('Quaffle goal' => 10, 'Caught Snitch' => 150 )


puts
puts '                                          JSON(Хэши хэшей и массивов)'

subscribers = Hash.new{ |h, k| h[k] = [] } # Новый хэш массивов

# При комбинации массивов и хешей получается уникальная структура данных, которую называют JSON (JavaScript Object Notation - мы уже говорили о том, что хеш в JavaScript часто называют “object”). Несмотря на то, что это название изначально появилось в JavaScript, в руби оно тоже широко используется
obj = {
  soccer_ball: { weight: 410, colors: [:red, :blue] },
  tennis_ball: { weight: 58, colors: [:yellow, :white] },
  golf_ball: { weight: 45, colors: [:white] }
}
# Мы намеренно записываем этот хеш универсальным образом, где ":white" это один элемент в массиве, который доступен по ключу ":colors". В этом случае говорят "сохранить схему [данных]"
arr = obj[:tennis_ball][:colors] #=> [:yellow, :white]
weight = obj[:golf_ball][:weight] #=> 45
# Добавим элемент
obj[:tennis_ball][:colors].push(:green)
obj[:tennis_ball][:colors] #=> [:yellow, :white, :green]

# Структура, которую мы определили выше начинается с открывающейся фигурной скобки. Это означает, что JSON имеет тип Hash. Но структура JSON может также быть массивом.
obj = [
  { type: :soccer_ball, weight: 410, colors: [:red, :blue] },
  { type: :tennis_ball, weight: 58, colors: [:yellow, :white] },
  { type: :golf_ball, weight: 45, colors: [:white] }
]


puts
# JSON Hash from string
def functionator(str) # var1
  hh1, hh2 = {}, {}
  str.split.reverse.each_with_index{|w, i| i == 0 ? hh1[w] = true : i.odd? ? (hh2[w], hh1 = hh1, {}) : (hh1[w], hh2 = hh2, {})}
  hh1.empty? ? hh2 : hh1
end
def functionator(string) # var2
  string.split.uniq.reverse.inject(true){ |assigned_value, key| { key => assigned_value } }
end
obj = functionator("there are two kinds of people") #=> {"there"=>{"are"=>{"two"=>{"kinds"=>{"of"=>{"people"=>true}}}}}}


puts
puts '                                                    Methods'

# В любом случае, используете ли вы библиотеку(gem), базу данных, язык руби или какой-то другой, для хеша всегда существует два основных метода:
#get(key) - получить значение (value)
#set(key, value) - установить значение для определенного ключа

hh = {:a =>'a', :b => 'b', :c => 'c'}
hh.keys       #=> [:a, :b, :c] #hh.keys это массив ключей а значит можно применять к нему методы массивов
hh.keys[1]    #=> b  # тк hh.keys это массив ключей, то hh.keys[1] возвращает элемент по индексу
hh.values     #=> ["a", "b", "c"] #возвращает массив значений
hh.has_key?:a #=> true  # Проверяет есть ли в данном хэше данный ключ(удобно для оператора if)
hh.key?:a     # сокращеная версия has_key?
if hh[:a]     # аналог предыдущему(более предпочтительный) если в if. (если hh[:a] != nil (такой ключ есть в хэше / true))
end
hh.has_value?('a')      #=> true  # Проверяет есть ли в данном хэше данное значение
hh.value?('a')          # сокращеная версия has_value?
hh.inspect              #=> "{:a =>'a', :b => 'b', :c => 'c'}" Возвращает хэш в виде строки
hh.clear                #=> очистить хэш
hh.map{ |k, v| [k, v] } # map авттоматичкски преобразует хэш в массив

eval("{:a=>1, :b=>2, :c=>3}") #=> {:a=>1, :b=>2, :c=>3}
eval("{:a=>1, :b=>2, :c=>3}").class #=> Hash

# Методы из-в Array
hh.sort_by { |k, v| v } #=> [[:a, "a"], [:b, "b"], [:c, "c"]]

# Сумма элементов из 2д хэша
hash = {"0"=>{"lease_item_id"=>"3", "subtotal"=>"100"}, "1342119042142"=>{"lease_item_id"=>"1", "subtotal"=>"100", "_destroy"=>"false"}}
sum = hash.values.reduce(0){|sum, inner| sum + inner["subtotal"].to_i } #=> 200


puts
puts '                                           Method "dig"'

# Оператор dig находит и возвращает объект во вложенных объектах, указанный ключом и/или иденксом(альтернатива написанию ключей один за одним).
hh = {foo: {bar: [:a, :b, :c]}}
hh.dig(:foo)          #=> {:bar=>[:a, :b, :c]}     # hh[:foo]
hh.dig(:foo, :bar)    #=> [:a, :b, :c]             # hh[:foo][:bar]
hh.dig(:foo, :bar, 2) #=> :c                       # hh[:foo][:bar][0]
hh.dig(:foo, :BAZ)    #=> nil                      # hh[:foo][:BAZ]
# Примечание: когда вы будете работать с Rails, вы столкнетесь с похожим методом “try” и т.н. safe navigation operator `&.`, в других языках программирования обозначается как `?.` Safe navigation operator похож по своей сути на метод dig.

# Пример. При итерации структур с большим коллич уровней вложенности удобно использовать метод dig
users = [
    { first: 'John', last: 'Smith', address: { city: 'San Francisco', country: 'US' } },
    { first: 'Pat', last: 'Roberts', address: { country: 'US' } },
    { first: 'Sam', last: 'Schwartzman' }
]
# Во второй записи отсутствует город. В третьей записи вообще нет адреса. Если мы хотим вывести на экран все города из этого массива, например через each, то возникнут ошибки изза невозможности операций над nil
users.each do |user|
  puts user[:address][:city]
end #=> undefined method `[]' for nil:NilClass (NoMethodError) #=> San Francisco
# 1й вариант решения это проверить что на каждом уровне вложенности нет nil:
users.each do |user|
  puts user[:address][:city] if user[:address] && user[:address][:city]
end #=> San Francisco
# Но если уровней много то условия получатся слишком большими и удобнее использовать оператор dig
users.each do |user|
  puts user.dig(:address, :city)
end #=> San Francisco


puts
puts '                                        Метод each для хэшей'

hh = {'Micke' => 8765, 'Bob' => 8543, 'Ray' => 4567}
# аналогично массиву только задается 2 переменные: для ключа и для значения(1я переменная - ключ, 2я переменная - значение)
hh.each do |key, value|
	puts "Its #{value} number of #{key}"
end
# При работе с хэшами нет гпрантии что оператор each выведет элементы по порядку, тк хэши нужны не для хранения по порядку.

puts
# Если значение не нужно, то переменную “v”(или “k”) можно опустить, написать с подчеркиванием вначале или вообще заменить на подчеркивание. Это не синтаксис языка, а общепринятые соглашения о наименовании (naming conventions), с помощью которых другим программистам будет известно о ваших намерениях:
hh.each do |k, _|
  puts "Name is #{k}"
end

# Отдельно для ключей
hh.each_key do |key|
	puts key
end

# Отдельно для значений
hh.each_value do |value|
	puts value
end


puts
puts '                                          Merge (hash): Объединение хешей'

# Объединение хэшей
book1 = {mike: 65, tom: 55}
book2 = {jessie: 22, den: 32}
book1.merge book2 #=> {:mike=>65, :tom=>55, :jessie=>22, :den=>32}  # не изменяет заданные хэши
book1.merge! book2 #=> {:mike=>65, :tom=>55, :jessie=>22, :den=>32} # изменяет хэш book1 добавляя в него элементы из book2

# С повторяющимися ключами значения будут браться у более поздних
hh = {foo: 0, bar: 1, baz: 2}
hh1 = {bat: 3, bar: 4}
hh2 = {bam: 5, bat:6}
hh.merge(hh1, hh2) # => {:foo=>0, :bar=>4, :baz=>2, :bat=>6, :bam=>5}

# С блоком для повторяющихся ключей
hh = {foo: 0, bar: 1, baz: 2}
hh1 = {bat: 3, bar: 4}
hh2 = {bam: 5, bat:6}
hh3 = hh.merge(hh1, hh2){|key, old_value, new_value| old_value + new_value}
hh3 # => {:foo=>0, :bar=>5, :baz=>2, :bat=>9, :bam=>5}

h1 = {"flour"=>200, "eggs"=>1, "sugar"=>100}
h2 = {"flour"=>100}
h1.merge(h2){|k, ov, nv| ov - nv} #=> {"flour"=>100, "eggs"=>1, "sugar"=>100}


puts
puts '                                        Набор ключей(Set)'

# https://ruby-doc.org/stdlib-3.0.2/libdoc/set/rdoc/Set.html

# Иногда возникает необходимость использовать только ключи в структуре данных “хеш”. Есть специальная структура данных, которая содержит только ключи(без значений). Она называется HashSet (в руби просто Set)
# Set представляет(реализует) собой коллекцию неупорядоченных неповторяющихся(!!!) значений

require 'set' # импортируем пространство имен, т.к. set не определен в пространстве имен по-умолчанию

# конвертирование массива в сет
nodes = ['server1','server1','server2']
nodes.to_set # #<Set: {"server1", "server2"}>

# вычитание сетов
[1,2,3,4,5].to_set - [1,2,3,5].to_set #=>#<Set: {4}>

# Пример использования: нужно определить: все ли буквы английского языка используются в этом предложении?(true - если в предложении содержатся все буквы и false - если каких-то букв не хватает). Т.к. в хеше не может быть дублированных значений, то максимальное количество ключей в хеше - 26 (количество букв английского алфавита). Если количество букв 26, то все буквы были использованы. Тут хорошо бы иметь хеш без значений, чтобы можно было сэкономить память и, самое главное, показать намерение — “значение нам не важно”. В этом случае идеально подходит структура данных HashSet
str = 'quick brown fox jumps over the lazy dog'
require 'set'
def f(str)
  set = Set.new # инициализируем set
  str.each_char do |c| # итерация по каждому символу в строке
    if c >= 'a' && c <= 'z' # только если символ между a и z (игнорируем пробелы и все остальное)
      set.add(c) # добавляем в set
    end
		break if set.size >= 26
  end
  set.size == 26 # результат выражения true, если есть все английские буквы в наборе
end
puts f(str) # выведет true, т.к. в этом предложении используются все буквы англ. алфавита
# Если строка довольно большая, а распределение символов равномерно, то вероятность того, что все символы встретятся где-то вначале очень высока. Поэтому проверка на размер HashSet довольно полезна и в теории должна сэкономить вычислительные ресурсы.
