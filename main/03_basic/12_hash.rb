puts '                                               Hash'

# https://www.youtube.com/watch?v=rPp46idEvnM      - устройство хэша и сета потом мб разобрать видос

# Hash / Хэшы / Хэш-таблицы / Ассоциативные массивы / Key value storage / Dictionary(словарь) -  представляют собой тип коллекции, подобный словарю, в котором данные хранятся парами, состоящими из уникальных ключей и соответствующих им значений. Элемент хэша это и ключ и значение, а не просто значение как в Аrray. Все имеющиеся в руби типы данных могут быть как ключами, так и значениями в ассоциативных массивах. Под капотом эти ключи хранятся в виде хэш-кодов.

# Хеш это как массив, для того чтобы получить элемент, нужен его индекс. Нужен способ превратить любое значение(строка например) в число(которое будет использовано как индекс). Этот способ - это хеш функция

# Хэш-код (или просто хэш) - строка символов или целое число фиксированного размера, что генерируется хэш-функцией на основе строки (или фаила) любого размера. Часто используемые типы хэш-функций: MD5, SHA-1 и CRC.

# В Ruby, когда мы сохраняем что-то в Hash, хэш функция принимает любой объект, предоставленный как ключ(например строку), преобразуется хэш-функцией и сохраняется как хеш-код(число). Одна и та же строка всегда будет превращена в одно и то же число. Это число будет использовано как индекс в массиве и по этому индексу будет записана эта строка. Позже, извлекая элемент из Hash-а, мы предоставляем объект в качестве ключа, который преобразуется в хэш-код и сравнивается с существующими ключами. Если есть совпадение, возвращается значение соответствующего элемента. Сравнение производится с помощью метода eql?.

# Остается вопрос с коллизиями(две разные строки хешируются к одному и тому же индксу) - это мы будем, например, заместо хранения по индексу строки в массиве, будем хранить другой массив, в котором будем хранить строки для которых совпали значения хеш функции.


# Ключи не обязательно сохраняют порядок, но в Руби порядок гарантируется (но не рекомендуется на него надеяться). В новых версиях Руби хеш, который содержит не более 7 элементов реализован через массив.

# Ключ должен быть уникальным
# Если попытаться получить доступ к хешу с помощью несуществующего ключа, метод вернет nil

# В случае поиска какого-либо объекта в хеше поиск происходит моментально(constant time, O(1))

# Использовать переменную с названием “hash” нельзя, тк это зарезервированное ключевое слово языка



puts '                                        Синтаксис. Инициализация'

# 1. Синтаксис и инициализация хэша с элементами через {}
name, pogonyalo = "Vasya", "Chotkiy"
some = {
	"Ключ1(Key1)" => "Значение1(Value1)",  # Обязательно ставить запятую после каждого элемента
  # => - Hash rocket символ для обозначения принадлежности значения ключу, универсален, при помощи него ключами можно задавать любые объекты
	Key2: 'Value2',                        # Современный вид с двоеточием вместо рокета.
	# : - символ для обозначения принадлежности значения ключу, при помощи него ключами можно задавать только строки или символы без двоетосия в начале. Если ключ не задается кавычками и его синтаксис соответствует он автоматически становится symbol, соответсвенно numeric нельзя обозначить двоеточием как ключ.
	# Двоеточие и рокет могут использоваться для разных ключей в одном хэше
	'Key3': 'Значение3(Value3)',           # 'Key3': - это будет символ(:'Key3 ') а не строка
  "RU" => 2.5,                           # ключ String
  1 => "Жопа",                           # ключ Integer (FixNum)
  UA: "pisya",                           # ключ :UA - Symbol
	# по ключам символам поиск быстрее чем по строкам, тк сравнение символов быстрее сравнения строк
	name => pogonyalo                      # ключ и значение из переменной
}

some          #=> {"Ключ1(Key1)"=>"Значение1(Value1)", :Key2=>"Value2", :Key3=>"Значение3(Value3)", "RU"=>2.5, 1=>"Жопа", :UA=>"pisya", "Vasya"=>"Chotkiy"}

# Значения хэша получаем по соответсвующему ключу
some["RU"]    #=> 2.5
some[1]       #=> Жопа
some[:UA]     #=> pisya

# альтернативный способ вызвать метод [], тоесть значение по ключу:
some.[](:UA)  #=> pisya


# Можно не указывать значения для элементов хэша, если они соответсвуют именам уже существующих переменных, значение будет извлечено из контекста по имени ключа:
x, y = 0, 100
hh = {x:, y:} #=> {:x=>0, :y=>100}


# 2. Инициализация нового пустого хэша через Hash.new и присвоение в него значений
student_marks = Hash.new
# если ключ или значение не существует, вернет nil
student_marks[7]                 #=> nil
student_marks['Literature'] = 74 # Создаем элемент хэша с ключем 'Literature' и значением 74
student_marks['Literature'] = 66 # Если такой ключ существует, то поменяем ему значение
student_marks['Literature'] += 1 # Изменим значение применив оператор к значению
student_marks['Science'] = 89
student_marks.store('Math', 91)  # store - метод тоже для добавления значений в хэш
student_marks #=> {"Literature"=>67, "Science"=>89, "Math"=>91}


# 3. Инициализация нового пустого хэша через Hash.new и присвоение в него значений
notebook = {}
notebook["Vasya"] = 34567
notebook["Petya"] = 56789
notebook #=> {"Vasya"=>34567, "Petya"=>56789}


# 4. Инициализация при помощи Hash[ ]
# из элементов хэша:
Hash[ "a" => 100, "b" => 200 ]  #=> {"a"=>100, "b"=>200}
# из 2D массива:
Hash[ [[0, :zero], [1, :one]] ] #=> {0=>:zero, 1=>:one}


# 5. Хэш из строки отформатированной как хэш при помощи eval
eval("{:a=>1, :b=>2, :c=>3}") #=> {:a=>1, :b=>2, :c=>3}
eval("{:a=>1, :b=>2, :c=>3}").class #=> Hash



puts '                                       Удаление элементов хэша'

# Тк элемент хэша это ключ+значение, то и удалить их можно только вместе, а по отдельности только заменить

dict = { 'cat' => 'кошка', 'dog' => 'собака', 'girl' => 'девочка' }

# delete - удаляет ключ и значение по ключу и возвращает значение
dict.delete('cat')
p dict #=> {"dog"=>"собака", "girl"=>"девочка"}

# exept - удаляет элемент по ключу и возвращает хэш
hh = {foo: 123, bar: {baz: 228}}.except(:foo) #=> {:bar=>{:baz=>228}}


# clear - метод полностью лчищает хэш от ключей и значений
dict.clear  #=> {}
dict        #=> ()



puts '                                        Значение по-умолчанию'

# Можно указать значение хэша по умолчанию. Если ключ или значение не существует, вернет значение по умолчанию

# 1. Если не указать значение по умолчанию, то оно будет равно nil
hh = {}
hh[7] #=> nil

# 2. Значение по умолчанию с синтаксисом инициализации Hash.new - просто задаем значение по умолчаю параметром в конструктор
hh = Hash.new(0)
p hh[7] #=> 0

# 3. default - метод установки значения по умолчанию уже существующему хэшу или хэшу заданному через синтаксис с {}
hh = {a: 'b'}
hh.default = 0
hh[:b] #=> 0


# При помощи значения по умолчанию...
hh = {}
word = 'some'
# ...можно заменить такую конструкцию:
if hh[word].nil? # нужно проверить: встречается ли ключ в хеше
	hh[word] = 1   # Если не встречается, то добавить новый ключ и начальное значение = 1
else
	hh[word] += 1  # Если встречается, то увеличить счетчик на 1
end
# установить значение по-умолчанию:
hh.default = 0
# теперь нам не нужно проверять на nil и отдельно задавать новый ключ и начальное значение
hh[word] += 1   # тк оно автоматически теперь изначально равно 0


# Удобно использовать и в предварительно созданных хэшах с существующими ключамию. Тепрь при операции со значением по несуществующему ключу будет использоваться значение по умолчанию(тут -30)
ACTION_SCORES = Hash.new(-30).update('Quaffle goal' => 10, 'Caught Snitch' => 150 ) #=> {"Quaffle goal"=>10, "Caught Snitch"=>150}



puts '                                    Хэши хэшей и массивов (JSON)'

# При комбинации массивов и хешей получается структура данных, которую называют JSON (JavaScript Object Notation). Несмотря на то, что это название изначально появилось в JavaScript, в Руби оно тоже широко используется

# Новый хэш массивов
subscribers = Hash.new{ |h, k| h[k] = [] }

# Добавление / изменение элементов JSON:
# Намеренно записываем этот хеш универсальным образом, где символ :white в массиве хоть он и один, тк по ключу ":colors", в других элементах массивы. В этом случае говорят "сохранить схему [данных]"
obj = {
  soccer_ball: { weight: 410, colors: [:red, :blue] },
  tennis_ball: { weight: 58, colors: [:yellow, :white] },
  golf_ball: { weight: 45, colors: [:white] }
}
obj[:tennis_ball][:colors][0]  #=> :yellow
obj[:golf_ball][:weight] += 5
obj[:golf_ball][:weight]       #=> 50
# Добавим элемент
obj[:tennis_ball][:colors].push(:green)
obj[:tennis_ball][:colors]     #=> [:yellow, :white, :green]

# Это означает, что JSON имеет тип Hash, если объект самого верхнего уровня - хэш. Но структура JSON может также быть массивом.
obj = [
  { type: :soccer_ball, weight: 410, colors: [:red, :blue] },
  { type: :tennis_ball, weight: 58, colors: [:yellow, :white] },
  { type: :golf_ball, weight: 45, colors: [:white] }
]



puts '                                      Копирование хэшей. dup и deep_dup'

# Если копировать хэш то просто будет новая ссылка на тот же хэш
DEFAULT_HASH = { a: 0, b: 1 }
my_hash = DEFAULT_HASH
my_hash[:a] = 4
# Теперь значение ":a" в my_hash и в DEFAULT_HASH равно 4
p DEFAULT_HASH #=> {:a=>4, :b=>1}
p my_hash      #=> {:a=>4, :b=>1}

# dup - метод делает поверхностную копию самого внешнего хэша
DEFAULT_HASH = { a: 0, b: 1 }.freeze
my_hash = DEFAULT_HASH.dup
my_hash[:a] = 4
# Теперь значение ":a" в my_hash и в DEFAULT_HASH равно 4
p DEFAULT_HASH #=> {:a=>0, :b=>1}
p my_hash      #=> {:a=>4, :b=>1}

# Но если есть внутренние объекты, то в новом хэше просто на них же копируются ссылки
DEFAULT_HASH = { a:{a:1, b:2}, b:{a:2, b:1} }
my_hash = DEFAULT_HASH.dup
my_hash[:b][:a] = 'AAA'
p my_hash      #=> {:a=>{:a=>1, :b=>2}, :b=>{:a=>"AAA", :b=>1}}
p DEFAULT_HASH #=> {:a=>{:a=>1, :b=>2}, :b=>{:a=>"AAA", :b=>1}}

# 1. Для глубокого копирования можно использовать Marshal::dump и Marshal::load:
default_hash = { a: { b: { c: { d: 4 } } } }
my_hash = Marshal.load(Marshal.dump(default_hash))
my_hash[:a][:b][:c][:d] = 44
p my_hash        #=> {:a=>{:b=>{:c=>{:d=>44}}}}
p default_hash   #=> {:a=>{:b=>{:c=>{:d=>4}}}}

# 2. Для глубокого копирования можно создать кастомный метод например в классе Hash
class Hash
  def deep_dup
    result = {}
    self.each do |k,v|
      result[k] = v.respond_to?(:deep_dup) ? v.deep_dup : v
    end
    result
  end
end
default_hash = { a: { b: { c: { d: 4 } } } }
my_hash = default_hash.deep_dup
my_hash[:a][:b][:c][:d] = 44
p my_hash        #=> {:a=>{:b=>{:c=>{:d=>44}}}}
p default_hash   #=> {:a=>{:b=>{:c=>{:d=>4}}}}



puts '                              Методы для работы с ключами и значениями'

hh = {:a =>'a', :b => 'b', :c => 'c'}

# Методы поиска и работы с ключами:
hh.has_key?(:a) #=> true           # Проверяет есть ли в данном хэше данный ключ
hh.key?(:a)     #=> true           # алиас для has_key?
true if hh[:a]  #=> true           # более надежный вариант чем key?, тк если hh[:a]== nil то такой ключ есть в хэше есть
hh.key('a')     #=> :a             # находит ключ по значению(если есть несколько одинаковых значений, вернет 1й найденный)
hh.keys         #=> [:a, :b, :c]   # вернет массив всех ключей

# Методы поиска и работы со значениями:
hh.has_value?('a') #=> true              # Проверяет есть ли в данном хэше данное значение
hh.value?('a')     #=> true              # алиас для has_value?
hh.values          #=> ["a", "b", "a"]   # возвращает массив всех значений



puts '                                      Методы итерации для хэшей'

hh = {'Micke' => 8765, 'Bob' => 8543, 'Ray' => 4567}

# each - передает в блок 2 переменные: 1я переменная - ключ, 2я переменная - значение. При работе с хэшами нет гпрантии что оператор each выведет элементы по порядку, тк хэши не всегда соблюдают порядок.
hh.each do |key, value|
	puts "Its #{value} number of #{key}"
end
# Если значение или ключ не нужно, то переменную “v”(или “k”) можно опустить, написать с подчеркиванием вначале или вообще заменить на подчеркивание. Это не синтаксис языка, а общепринятые соглашения о наименовании (naming conventions), с помощью которых другим программистам будет известно о ваших намерениях:
hh.each { |k, _| puts "Name is #{k}" }


# each_key - итератор отдельно для ключей
hh.each_key { |key| puts key }


# each_value - итератор отдельно для значений
hh.each_value { |value| puts value }



puts '                                           Method dig'

# dig - находит и возвращает объект во вложенных объектах, указанный ключом и/или иденксом(альтернатива написанию ключей один за одним). Похож на safe navigation operator `&`
hh = {foo: {bar: [:a, :b, :c]}}
hh.dig(:foo)          #=> {:bar=>[:a, :b, :c]}     # hh[:foo]
hh.dig(:foo, :bar)    #=> [:a, :b, :c]             # hh[:foo][:bar]
hh.dig(:foo, :bar, 2) #=> :c                       # hh[:foo][:bar][0]
hh.dig(:foo, :BAZ)    #=> nil                      # hh[:foo][:BAZ]

# Удобен при итерации структур с большим коллич уровней вложенности
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



puts '                                      Метод merge (Объединение хешей)'

# Объединение хэшей
book1 = {mike: 65, tom: 55}
book2 = {jessie: 22, den: 32}
book1.merge book2  #=> {:mike=>65, :tom=>55, :jessie=>22, :den=>32}  # не изменяет заданные хэши
book1.merge! book2 #=> {:mike=>65, :tom=>55, :jessie=>22, :den=>32}  # изменяет хэш book1 добавляя в него элементы из book2

# С повторяющимися ключами значения будут браться у более поздних
hh = {foo: 0, bar: 1, baz: 2}
hh1 = {bat: 3, bar: 4}
hh2 = {bam: 5, bat:6}
hh.merge(hh1, hh2) # => {:foo=>0, :bar=>4, :baz=>2, :bat=>6, :bam=>5}

# С блоком для учета всех повторяющихся ключей
hh = {foo: 0, bar: 1, baz: 2}
hh1 = {bat: 3, bar: 4}
hh2 = {bam: 5, bat:6}
hh3 = hh.merge(hh1, hh2){|key, old_value, new_value| old_value + new_value}
hh3 # => {:foo=>0, :bar=>5, :baz=>2, :bat=>9, :bam=>5}



puts '                                         Метод inject/reduce'

# inject/reduce - возвращает объект, сформированный из операндов с помощью метода, заданного символом.

# Hash update.
hh = [{foo: 0, bar: 1}, {baz: 2}, {bat: 3}].inject(:update) #=> {:foo=>0, :bar=>1, :baz=>2, :bat=>3}
# Hash conversion to nested arrays.
hh = {foo: 0, bar: 1}.inject([], :push) #=> [[:foo, 0], [:bar, 1]]



puts '                                         Методы Hash => Array'

hh = {:a =>'a', :b => 'b', :c => 'c'}

# Методы предварительно автоматически преобразующие хэш в Array:
hh.map{ |k, v| [k, v] } #=> [[:a, "a"], [:b, "b"], [:c, "c"]]
hh.sort_by { |k, v| v } #=> [[:a, "a"], [:b, "b"], [:c, "c"]]



puts '                                           Разное. Решения'

# JSON Hash from string
def functionator(str, hh1={}, hh2={})
  str.split.reverse.each_with_index{|w, i| i == 0 ? hh1[w] = true : i.odd? ? (hh2[w], hh1 = hh1, {}) : (hh1[w], hh2 = hh2, {})}
  hh1.empty? ? hh2 : hh1
end
obj = functionator("there are two kinds of people") #=> {"there"=>{"are"=>{"two"=>{"kinds"=>{"of"=>{"people"=>true}}}}}}


# Сумма элементов из 2д хэша
hash = {
	"0"=>{"lease_item_id"=>"3", "subtotal"=>"100"},
	"1342119042142"=>{"lease_item_id"=>"1", "subtotal"=>"100", "_destroy"=>"false"}
}
hash.values.reduce(0){|sum, inner| sum + inner["subtotal"].to_i } #=> 200















#