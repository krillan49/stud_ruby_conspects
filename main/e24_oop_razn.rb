puts '                               ООП. Наследование, доступ, статические методы, self'


# https://habr.com/ru/articles/87205/   -   определения наследования, инкапсуляции, абстракции, полиморфизма

# В большинстве объектно-ориентированных языков, основанных на классах, объект, созданный путем наследования, «дочерний объект», приобретает все свойства и поведение «родительского объекта», за исключением: конструкторов, деструкторов, перегруженных операторов и функций друга базового класса.


puts
puts '                                            Наследование(inheritance)'

# Наследование(inheritance) - позволяет создать класс, что будет иметь(наследовать) все методы, поля и конструкторы главного класса. Так в подклассе можно использовать все необходимые основные методы надкласса, но при этом расширить функционал для каждого класса-наследника отдельно, добавив в него и свои уникальные методы и свойства, не распространяющиеся на материнский класс или другие классы наследники.
# Наследование может быть многоуровневым, когда класс наследник от одного класса является сам суперклассом для третьего.
# Материнский класс так же называется суперклассом
class Transport
  attr_accessor :color, :wheels

  def say_bip
    puts "BipBip"
  end
end

class Car < Transport # Знаком < обозначаем, что класс Car унаследует все свойства, методы и конструктор у класса Transport
  attr_accessor :is_mechanic # Переменная(свойство) подкласса, не затрагивающая материнский класс

  def kolesa # При помощи метода тоже можно обращаться к переменной из материнского класса
    puts @wheels + 2 # значение этой переменной мат класса у объекта подкласса мы задали ниже
  end
end

class Moto < Transport
  def say_bip # Если мы создаем тот же метод и в подклассе, то мы его переопределяем для этого подкласса
    puts "Тыц Тыц"
  end
end

bmw = Transport.new()
bmw.say_bip #=> "BipBip"

audi = Car.new() # Объект audi класа Car, обладает всеми свойствами и родительского класса Transport и своими собственными
audi.color = "Black" # Задаем значение переменной материнского класса объекту подкласса
audi.wheels = 4

audi.say_bip #=> "BipBip"  # Метод из род класса Transport, работает на объекте подкласса Car
audi.color #=> "Black"  # Выводим значение переменной материнского класса у объекта подкласса
audi.kolesa #=> 6 #(4 + 2)

mers = Moto.new()
mers.say_bip #=> "Тыц Тыц"  # Метод выводит из подкласса, тк мы его переопределили

mers.class #=> Moto
mers.class.superclass #=> Transport


puts
# Пример с классом почти таким же как сушествующий класс Hash но с другим способом вызова значения(по части ключа, при одинаковых по алфавиту)
class Xuesh < Hash
  def [](key)
    arr = self.clone.to_a
    arr.select{|k,v| k.start_with?(key)}.sort_by{|k,v| k}[0][1] rescue nil
  end
end

def partial_keys(hh)
  xuesh = Xuesh.new
  hh.each{|k,v| xuesh[k] = v}
  xuesh
end
subject = partial_keys({"aaa" => 1,"abc" => 2,"dfg" => 3,"def" => 4,"dfgh" => 5,"undefined" => 6})
p subject['aa']# 1
p subject['ab']# 2
p subject['df']# 3
p subject['de']# 4
p subject['dfg']# 3
p subject['dfgh']# 5
p subject['b']# nil


puts
puts '                                           Subtyping (субтипирование)'

# Субтипирование использует механизм наследования для того чтобы выделить подтипы. Классы наследники являются подтипами к тому суперклассу, который обычно абстрактен и сам по себе не используется а лишь содержит общий функционал для подклассов(для выделения общей функциональности)
class Player # Абстрактный класс Player содержит общую функциональность для всех подклассов, но при этом сам не используется
  attr_accessor :x

  def initialize(x)
    @x = x
  end
  def right
    self.x += 1
  end
  def left
    self.x -= 1
  end
  def label # Пустой метод(можно убрать) говорит нам что он присудствует во всех подклассах и везде будет разным
  end
end
# Классы Robot и Dog будут являться подтипами класса Player
class Robot < Player
  def label
    '*'
  end
end
class Dog < Player
  def left # Переназначаем метод ограничивая направление движения объектов подкласса Dog
  end
  def label
    '@'
  end
end

# ПРИМЕЧАНИЕ: при использовании наследования важно избежать неверной абстракции, например не сделать суперклассом тот класс, который впоследствии возможно нужно будет менять так, что изменения пойдут вразрез с функциональностью классов наследников, по этой причине иногда даже дублирование кода может быть предпочтительнее. Если вы не уверены в выбранной абстракции, используйте модули и честно копируйте код. Если вам кажется, что абстракция правильная, то создавайте абстрактный класс, который будет содержать общие для всех подклассов методы и данные.


puts
puts '                                     Наследование и конструктор. super'

# super - специальное слово при помощи которого можно передать значение из конструктора подкласса в конструктор суперкласса и соотв в его переменную. (?)Либо так как мы переопределяем конструктов в подклассе, соотв мы копируем при помощи super конструктор из суперкласса, добаляя в него новые переменные или значения.
class Animal
	def initialize name # 2. Значение 'cat' передается в параметр конструктора
		@name = name # 3. и затем в глобальную переменную суперкласса
	end

  def run
    puts "#{@name} is runing..." # 5. Теперь можно использовать значение 'cat' для методов суперкласса объектами подкласса
  end
end

class Cat < Animal
	def initialize
		super 'cat' # 1. Значение 'cat' мы передаем в конструктор суперкласса Animal при помощи специального слова super
	end

  def meow
    puts "#{@name} meow" # 4. Теперь можно использовать значение 'cat' для методов подкласса
  end
end

cat1 = Cat.new
cat1.run #=> "cat is runing..."
cat1.meow #=> "cat meow"


puts
# super нужен чтобы изменить переменные экземпляра в классе наследнике, если менять переменные без него, то весь конструктор переопределится и не будет переменных мат класса
class Character
  attr_accessor :strength, :constitution
  def initialize
    @strength = 5
    @constitution = 5
  end
end

class Orc < Character
  def initialize
    super
    @strength = 7
  end
end

class Elf < Character
  def initialize
    @strength = 3
  end
end

ork = Orc.new
p ork.constitution # => 5
elf = Elf.new
p elf.constitution # => nil


puts
# super  Передача переменных из конструктора подкласса(наоборот?) в конструктор суперкласса. Передача значений из метода подкласса в метод суперкласса
class Song
  def initialize(name, artist, duration)
    @name     = name
    @artist   = artist
    @duration = duration
  end

  def to_info_S
    "Song: #{@name}--#{@artist} (#{@duration})"
  end
end

class KaraokeSong < Song
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration) # передаем переменные в(из?) конструктор суперкласса для того чтоб добавить новую в этот класс без новой инициализации тех же переменных в конструкторе подкласса. Если новая переменная не нужна, то можно обойтись без передачи(и без конструктора подкласса) и объект подкласса будет автоматически передавать значеня в конструктор суперкласса
    @lyrics = lyrics
  end

  def to_info_KS
    "KS: #{@name}--#{@artist} (#{@duration}) [#{@lyrics}]" # используем переменные подкласса
  end

  def to_info_S # Метод подкласса с тем же названием что и метод суперкласса передает к возвращаемому значению из метода суперкласса    + " [#{@lyrics}]"
    super + " [#{@lyrics}]" # используем переменные переданные в суперкласс
  end
end

aSong = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the...")
aSong.to_info_KS #=> "KS: My Way--Sinatra (225) [And now, the...]"
aSong.to_info_S #=> "Song: My Way--Sinatra (225) [And now, the...]"


puts
puts '                                   self (указание метода на объект класса)'

# Переменная self - спец символ(означет тот объект к которому будет применяться метод)
# Переменная self должна знать класс объекта к которому ссылается, соответвенно применима только в теле класса.
class Array
  def second
    self[1] # Элемент с индексом 1 в объекте к которому будет применен метод
  end
end
[3, 4, 5].second #=> 4


puts
# способы изменения(изменение на месте) self в методе а не просто возврат измененного self
class Array
  def transpose!
    replace(transpose)
    # self.replace(transpose)
    # replace(self.transpose)
    # self.replace(self.transpose)
    # self[0..-1] = transpose
  end
  # define_method(:transpose!) { replace(transpose) }
  def exchange_with!(arr)
    clone = arr.clone
    arr.replace(self.reverse)
    self.replace(clone.reverse)
  end
end
a = [[1, 2, 7], [3, 5, 6]]
a.transpose!
p a #=> [[1, 3], [2, 5], [7, 6]]

room_a = ["1", "2", "3", "4", "5", "6", "7"]
room_b = ["a", "b", "c"]
room_a.exchange_with!(room_b)
p room_a# ["c", "b", "a"]
p room_b# ["7", "6", "5", "4", "3", "2", "1"]

puts
# тоже но с внешним методом вар 1
class Array
  def transpose!
    replace(transpose)
  end
end
def rotate_in_place(matrix)
  matrix.reverse!.transpose!
end
matrix2 = [[1, 2],[3, 4]]
p rotate_in_place(matrix2)# rmatrix2
p matrix2

# вар2
def rotate_in_place(matrix)
  matrix.replace(matrix.reverse.transpose)
end


puts
# Возврат объекта для вызова нескольких методов подряд при помощи ключевого слова self
class List
  attr_accessor :counter, :items
  def initialize
    @items = []
    @counter = 0
  end

  def add(item)
    @items << item
    @counter += 1
    self #Метод возвращает сам объект к которому обращается, потому снова может быть применен к нему в той же строке
  end
end

list = List.new
p list.add(3).add(1).counter #=> 2  #.add(1) и .counter работают корректно, тк каждый раз возвращается объект
p list.items #=> [3, 1]


puts
puts '                                  self (обращение объекта к своему свойству)'

# Альтернативный синтаксис обращения к instance variable - через self вместо @. Полезно для инкапсуляции
class Robot
  attr_accessor :x, :y
  def initialize
    @x, @y = 0, 0
  end

  def right
    self.x += 1 # Обращаемся к атрибуту через self(а к self через метод от объекта) меняя значение переменной для объекта на заданное методом
  end
  def left; self.x -= 1 end
  def up; self.y += 1 end
  def down; self.y -= 1 end
end

robot1 = Robot.new
robot1.up #=> 1 (@y += 1) # Меняем значение переменной(состояние объекта) @y в соотв с тем как задоно в методе up вместо того чтоб менять его при вызове, если вызывать просто через атрибут
robot1.up #=> 2 (@y += 1)
robot1.right #=> 1 (@x += 1)
puts "x = #{robot1.x}, y = #{robot1.y}" #=> "x = 1, y = 2"

# Создаем массив роботов и передаем им случайный метод при помощи функции send и массива символов с именами методов
arr = Array.new(10) { Robot.new }
arr.each do |robot|
  m = [:right, :left, :up, :down].sample
  robot.send(m)
end


puts
puts '                               Обращение объекта к другому объекту через метод'

# Можно обращаться от объекта не только к самому себе, но и к другому объекту этого класса, вызывая его атрибуты и методы
class Someobj
  attr_reader :name, :rounded

  def initialize name, rounded
    @name, @rounded = name, rounded
  end

  def its_rounded? # К методу тоже можно обратиться от другого объекта
    @rounded
  end

  def name_self # Объект может обратиться только к себе
    self.name
  end

  def name_any(figure) # Можно обратиться и к себе и к другому объекту через параметр метода
    figure.name # Можно обратиться к переменной через атрибут
  end

  def rounded_any(figure)
    figure.its_rounded? # Можно обратиться к данным через метод доступа
  end
end

oval = Someobj.new('Oval', true)
kvadrat = Someobj.new('Kvadrat', false)
p oval.name_any(oval) #=> "Oval"  # Обращение к своему атрибуту
p oval.name_any(kvadrat) #=> "Kvadrat"  # Обращение к атрибуту другого объекта
p oval.rounded_any(oval) #=> true  # Обращение к своему значению переменной через метод
p oval.rounded_any(kvadrat) #=> false  # Обращение к значению переменной другого объекта через метод


puts
puts '                                    Class Methods или статические(static) методы'

# Методы класса(статические методы) могут иметь дело с управлением всеми существующими экземплярами класса и работают без привязки к какому-либо конкретному объекту, а методы экземпляра класса(instance methods) имеют дело с одним экземпляром за раз. Например, чтобы подсчитать количество объектов, принадлежащих классу, вам нужен метод класса
# методы класса запускаются в контексте класса (и имеют доступ только к переменным класса)
# методы экземпляра запускаются в контексте объекта (и имеют доступ к переменным объекта/экземпляра)
# доступ к методу класса осуществляется через класс, а к методу экземпляра — через экземпляр/объект класса
# Например метод new является методом класса и создает новый объект, но сам по себе не связан с конкретным объектом.
# Можно найти методы классов во всех библиотеках Ruby, например class File предоставляет несколько методов класса для работы с файлами, которые не открыты и, следовательно, не имеют объекта File.
class Example
  # instance method(метод экземпляра):
  def inst_meth
  end

  # class methods:
  def Example.class_meth # Синтаксис 1. Статический метод(метод класса) определяется префиксом с именем класса.
    puts 'hi'
  end

  def self.static_meth # Синтаксис 2. Статический метод(метод класса) определяется ключевым словом(в виде префикса) self
    puts 'bay'
  end
end
# Используя статический метод мы можем пользоваться таким упрощенным синтаксисом вызова метода:
Example.class_meth #=> "hi"
Example.static_meth #=> "bay"

# ПРИМЕЧАНИЕ: делать классы только со статическими методами не рекомендуется — нужно использовать модули. Классы следует использовать только тогда, когда имеет смысл создавать из них экземпляры.
# Класс содержащий только статические переменные(@@) и статические методы называется статическим классом


puts
# Например когда программа небольшая и нужен только 1 объект писать object_name = Classname.new не очень удобно(излишне) тогда стоит использовать упрощенный синтаксис статичкских методов.
# Используется часто для того, чтоб разбить программу на отдельные блоки, чтоб удобно было разным программистам работать над отдельными блоками. Пример программы(части какой-то игры) разбитой на отдельные блоки:
class RandomEngine
  def self.get_random_value
    rand(100..999)
  end
end
class GameEngine
  def self.play
    a = RandomEngine.get_random_value
  end
end
GameEngine.play


puts
# Передача объекта в метод класса в виде параметра
# Пример: Отсев песен превышающих заданное максимальное время.
class Song
  attr_reader :duration
  def initialize duration
    @duration = duration
  end

  def Song.is_too_long?(song) # Метод получает параметром объект
    song.duration > 300
  end
end

song1 = Song.new(260)
p Song.is_too_long?(song1) #=> false
song2 = Song.new(468)
p Song.is_too_long?(song2) #=> true


puts
# Использование методов класса в качестве псевдоконструктора(создание объектов):
# Применяется когда объекты класса нужно будет задавать по параметрам отличным от изначальных
class Shape
  attr_accessor :num_sides, :perimeter

  def initialize(num_sides, perimeter)
    @num_sides, @perimeter = num_sides, perimeter
  end
  # Методы класса которые будут возвращать заданные объекты класса(создавать новые объекты вместо метода new - псевдоконструктор) запрашивая при этом параметры отличные от тех что запрашивает конструктор и задавая при помощи них(и/или отдельно) параметры для конструктора.
  def Shape.triangle(side_length)
    Shape.new(3, side_length * 3)
  end
  def Shape.square(side_length)
    Shape.new(4, side_length * 4)
  end
end
# Объект созданный через конструктор напрямую с обращением к конструктору(new)
figure = Shape.new(5, 50) # требует число сторон и периметр
# Объект созданный через метод класса являющийся псевдоконструктором(triangle)
figure2 = Shape.triangle(8) # требует длинну стороны
p figure2 #=> #<Shape:0x0000012fe78b8f40 @num_sides=3, @perimeter=24>
p figure2.num_sides #=> 3
p figure2.perimeter #=> 24


puts
puts '                          Уровни доступа(public private protected) к методам'

# class API - набор публичных(доступных для использования) методов класса
# public methods(Публичные методы) - методы класса которы мы можем вызывать напрямую используя название метода для объекта. По умолчанию все методы относятся к public. Если было заданно ключевое слова другого уровня доступа, то чтобы дальнейшие методы были в публичном доступе нужно использовать ключевое слово public.
# private methods(Частные методы) - медоды идущие после ключевого слова private, которые вызвать напрямую через их имя нельзя. Можно вызвать только опосредованно через другой метод класса, если этот метод вызывается в соответствующем методе класса.
# protected methods - защищённый интерфейс — защищенный метод может вызываться только объектами определяющего класса и его подклассов. Мы не можем вызвать protected метод объекта непосредственно, но один объект может вызвать защищенный метод для себя или любого другого родственного объекта. В классическом ООП имеет немного другой смысл чем в Руби.
# Ограничение доступа нужно(например) чтоб разбивать программу на отдельные методы внутри класса для удобства
# Ruby не применяет никакого контроля доступа к переменным экземпляра и классам.
class Animal
  def initialize name
    @name = name
  end

  # По умолчанию все методы класса публичные.

  def run # Публичный метод доступен напрямую
    puts "#{@name} is runing"
  end

  def jump
    eat # Так можно вызвать private метод eat обратившись к публичному методу jump. Теперь метод eat будет вызван как элемент метода jump.
    puts "#{@name} is jumping"
  end

  private # Ключевое слово назначающее нижестоящие методы приватными

  def eat
    puts 'I am eating'
  end

  public # Ключевое слово назначающее нижестоящие методы публичными

  def say
    puts 'hello'
  end

  def say2
    puts 'hello'
  end
  def say3
    puts 'hello'
  end

  private :say2, :say3 # альтернативный синтексис для задания уровня доступа, пишется в любом месте но ниже тех методов которым задает уровень доступа

  def eat_of(animal)
    animal.eat # Обращается к private method - eat
  end

  def stay_of(animal)
    animal.stay # Обращается к protected method - stay
  end

  def stay
    puts "#{@name} stoping"
  end

  protected :stay
end

class Dog < Animal
	def initialize
		super 'dog'
	end

	def bark
    eat # можно вызывать private methods суперкласса из методов подкласса
		puts 'woof'
	end

  def dog_stay_of(animal)
    animal.stay # Обращается к protected method - stay
  end

  def wooo
    stay # protected method так же как и private и public можно вызвать из тела другого метода
    puts 'woooooo'
  end
end

animal1 = Animal.new('cat')
animal2 = Animal.new('monkey')
dog = Dog.new

# public methods
animal1.run #=> "cat is runing"
animal1.say #=> "hello"

# private methods
animal1.eat #=> `<main>': private method `eat' called for #<Animal:0x0000019b1af41670 @name="cat"> (NoMethodError)  #Нельзя вызвать этот метод напрямую, тк он private
animal1.say3 #=> `<main>': private method `say3' called for #<Animal:0x00000142d4548428 @name="cat"> (NoMethodError)
animal1.jump #=> "I am eating" "\ncat is jumping" #опосредованный вызов приватного метода eat из тела публичного метода jump. Теперь наша кошка моет поесть только когда попрыгает.
dog.jump #=> "I am eating" "\ndog is jumping" # private methods суперкласса могут вызываться и объктами подкласса
dog.bark #=> "I am eating" "\nwoof" # private methods суперкласса могут вызываться и методами подкласса
animal1.eat_of(animal2) #=> private method `eat' called for #<Animal:0x000002403062ba48 @name="monkey"> (NoMethodError)  # Приватный метод не может быть вызван при помощи обращения от объекта(себя или другого)

# protected methods
animal2.stay #=> `<main>': protected method `stay' called for #<Animal:0x000002034d70fb28 @name="monkey"> (NoMethodError)  # Не может быть вызван напрямую.
animal2.stay_of(animal1) #=> "cat stoping"  # Может быть вызван при обращении к себе или другому объекту
dog.dog_stay_of(animal2) #=> "monkey stoping"  # Может быть вызван от объекта класса наследника при обращении к себе или другому объекту подкласса или суперкласса
dog.stay_of(animal2) #=> "monkey stoping" # Может быть вызван от объекта класса наследника при обращении к себе или другому объекту подкласса или суперкласса
dog.wooo #=> "dog stoping\n" "woooooo"
