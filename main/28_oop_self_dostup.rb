puts '                                     ООП. Доступ, self'


puts
puts '                               self (указание метода на объект класса)'

# Переменная self - спец переменная/объект, означет тот объект к которому будет применяться метод(там где выполняется программа/инструкции, те ссылка на текущий контекст)
p self #=> main   # main - общее пространство, которое существует все всех классов
p self.class #=> Object   # те main это экземпляр класса Object
class Array
  p self #=> Array  # те в контексте класса указывает на класс
  def second
    p self #=> [3, 4, 5]  # в контексте метода указывает на конкретный объект
  end
end
[3, 4, 5].second
def some
  p self #=> main
end
some()

# ? Переменная self должна знать класс объекта к которому ссылается, соответвенно применима только в теле класса. ?
class Array
  def second
    self.first
    first # равнозначно предыдущему(сперва интерпритатор поищет переменную first и когда не найдет будет искать метод в контексте объекта, тк вызвано в методе экземпляра)
    self[1] # Элемент с индексом 1 в объекте(тут массиве) к которому будет применен метод
  end
end
[3, 4, 5].second #=> 4


puts
# replace. способы изменения(изменение на месте)
class Array
  def transpose!
    replace(transpose) # self не обязательны, тк у Array есть методы экземпляра replace и transpose
    # Альтернаривы: 1. self.replace(self.transpose) 2. self[0..-1] = transpose
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
    self # Метод возвращает сам объект к которому обращается, потому снова может быть применен к нему в той же строке
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
    self.x += 1 # Обращаемся к атрибуту(тут к сеттеру) через self
  end
  def left; self.x -= 1 end
  def up; self.y += 1 end
  def down; self.y -= 1 end
end

robot1 = Robot.new
robot1.up #=> 1 (@y += 1) # Меняем значение переменной(состояние объекта) @y в соотв с тем как задоно в методе up вместо того чтоб менять его при вызове, если вызывать просто через атрибут
robot1.right #=> 1 (@x += 1)
p "x = #{robot1.x}, y = #{robot1.y}" #=> "x = 1, y = 1"

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

  def its_rounded? # К методу тоже можно обратиться от переданного объекта
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
puts '                          Уровни доступа(public private protected) к методам'

# class API - набор публичных(доступных для использования) методов класса

# 1. public methods(Публичные методы) - методы класса которы мы можем вызывать напрямую используя название метода для объекта. По умолчанию все методы относятся к public. Если было заданно ключевое слова другого уровня доступа, то чтобы дальнейшие методы были в публичном доступе нужно использовать ключевое слово public.
# 2. private methods(Частные методы) - медоды идущие после ключевого слова private, которые вызвать напрямую через их имя нельзя. Можно вызвать только опосредованно через другой метод класса, если этот метод вызывается в соответствующем методе класса.
# 3. protected methods - защищённый интерфейс — защищенный метод может вызываться только объектами определяющего класса и его подклассов. Мы не можем вызвать protected метод объекта непосредственно, но один объект может вызвать защищенный метод для себя или любого другого родственного объекта. В классическом ООП имеет немного другой смысл чем в Руби.

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

  private # Ключевое слово назначающее нижестоящие методы приватными

  def eat
    puts 'I am eating'
  end

  public # Ключевое слово назначающее нижестоящие методы публичными

  def jump
    eat # Так можно вызвать private метод eat обратившись к публичному методу jump. Теперь метод eat будет вызван как элемент метода jump.
    puts "#{@name} is jumping"
  end

  def say1
    puts 'hello'
  end
  def say2
    puts 'hi'
  end

  private :say1, :say2 # альтернативный синтексис для задания уровня доступа, пишется в любом месте но ниже тех методов которым задает уровень доступа

  # Далее методы public, тк вышестоящий private принмает параметры и не затрагивает методы нижк

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

  private def met(n) # синтаксис для того чтобы сделать приватным конкретный метод(не затрагивает методы ниже)
    'gfghfgfh'
  end

  def some_some
    'some some'
  end
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
p animal1.some_some #=> "some some"

# private methods
animal1.eat #=> `<main>': private method `eat' called for #<Animal:0x0000019b1af41670 @name="cat"> (NoMethodError)  #Нельзя вызвать этот метод напрямую, тк он private
animal1.say3 #=> `<main>': private method `say3' called for #<Animal:0x00000142d4548428 @name="cat"> (NoMethodError)
animal1.jump #=> "I am eating" "\ncat is jumping" #опосредованный вызов приватного метода eat из тела публичного метода jump. Теперь наша кошка моет поесть только когда попрыгает.
dog.jump #=> "I am eating" "\ndog is jumping" # private methods суперкласса могут вызываться и объктами подкласса
dog.bark #=> "I am eating" "\nwoof" # private methods суперкласса могут вызываться и методами подкласса
animal1.eat_of(animal2) #=> private method `eat' called for #<Animal:0x000002403062ba48 @name="monkey"> (NoMethodError)  # Приватный метод не может быть вызван при помощи обращения от объекта(себя или другого)
animal1.met(2) #=> private method `met' called for

# protected methods
animal2.stay #=> `<main>': protected method `stay' called for #<Animal:0x000002034d70fb28 @name="monkey"> (NoMethodError)  # Не может быть вызван напрямую.
animal2.stay_of(animal1) #=> "cat stoping"  # Может быть вызван при обращении к себе или другому объекту
dog.dog_stay_of(animal2) #=> "monkey stoping"  # Может быть вызван от объекта класса наследника при обращении к себе или другому объекту подкласса или суперкласса
dog.stay_of(animal2) #=> "monkey stoping" # Может быть вызван от объекта класса наследника при обращении к себе или другому объекту подкласса или суперкласса
dog.wooo #=> "dog stoping\n" "woooooo"

















#
