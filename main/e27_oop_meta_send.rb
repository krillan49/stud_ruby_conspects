puts                                          'Функция send'

# send - альтернативный способ вызова метода (отправка сообщений объекту) который позволяет задавать имя метода объектом класса symbol или string, которые можно присваивать значениями в переменные или ключами в хэши
# Вызов функции при помощи send - мета-программирование.

def mm
  'hi'
end
p mm        #=> "hi"   # Стандартный способ вызова
p send :mm  #=> "hi"   # Вызов при помощи send 1й вариант
p send "mm" #=> "hi"   # Вызов при помощи send 2й вариант

# Этим способом мы можем вызвать метод присвоенный в переменную, в том числе с пользовательским вводом:
a = gets.strip # если введем имя функции вызываемой сенд, то она будет вызвана или не будет если имя не подходит.
send a


# Передача аргументов осуществляется через запятую после имени метода
def nn par1, par2
  "num #{par1} str #{par2}"
end
p send :nn, 555, 'aaa' #=> "num 555 str aaa"
p send 'nn', 555, 'aaa' #=> "num 555 str aaa"

# Передача хэша
def nm hh
  p "x #{hh[:x]} y #{hh[:y]}"
end
nm x: 1, y: 2          #=> "x 1 y 2"
send :nm, x: 1, y: 2   #=> "x 1 y 2" # Передаем хэш через send
send 'nm', x: 1, y: 2  #=> "x 1 y 2"


# Можно использовать для ленивого вывода(вывести лямбду из которой при желании уже потом можно будет вывести результат)
def add(a, b)
  a + b
end
def make_lazy(func , *args)
  lambda{send func, *args}
end
p make_lazy :add, 2, 3       #=> #<Proc:0x00000256c34e2138 E:/doc/ruby_exemples/test3.rb:6 (lambda)>
p make_lazy(:add, 2, 3).call #=> 5

# Пример с применением внешнего метода из класса
class String
  def every_char(method)
    self.chars.map{|e| send(method, e)}.join
  end
end
def f(c)
  c.upcase
end
p "hello".every_char(:f) #=> "HELLO"


# Вызов метода экземпляра через send
def dynamic_caller(obj, method)
  obj.send method
end
p dynamic_caller('zaphod beeblebrox', :upcase) #=> "ZAPHOD BEEBLEBROX"


# send для математических операторов. Передача оператора и присвоение send объекту
def basic_op(operator, value1, value2)
  value1.send(operator, value2)
end
p basic_op('+', 3, 2) #=> 5


# Пример с аргументами для метода и параллельной передачей блока(создание нового метода принимающего аргументы или блоки)
class Array
  def each_count(*args, &block)
    raise ArgsBlockSametime if args != [] && block
    if block
      self.map(&block).tally # (&block) == {|e| block.call(e)}
    elsif args != []
      self.map{|e| e.send(*args)}.tally
    else
      self.tally
    end
  end
end
cities = ["Melbourne", "Dallas", "Taipei", "Toronto", "Dallas", "Kathmandu"]
cities.each_count # {"Melbourne"=>1, "Dallas"=>2, "Taipei"=>1, "Toronto"=>1, "Kathmandu"=>1}
cities.each_count(:length) # {9=>2, 6=>3, 7=>1}
cities.each_count(:gsub, /[aeiou]/, 'x') # {"Mxlbxxrnx"=>1, "Dxllxs"=>2, "Txxpxx"=>1, "Txrxntx"=>1, "Kxthmxndx"=>1}
cities.each_count{|city| city.length % 3 == 0} # {true=>5, false=>1}
cities.each_count(:length) {|city| city.length % 3 == 0} # raise ArgsBlockSametime


puts
puts '                          Инициализация переменных экземпляра при помощи send'

# Мета-программирование используется для инициализации свойств класса
class Something
  attr_accessor :name # при объявлении attr_accessor, создаются методы name и name= для переменной @name
  def initialize
    send('name=', 'Mike') # инициализация переменной: обращается к методу name= присваиваем переменной значение 'Mike'
  end
end
s = Something.new
s.name #=> "Mike"

# Объявление переменных через хэш при помощи send. Удобно использовать если нужно инициализировать много переменных.
class Some
	attr_accessor :x, :y
	def initialize hash
		hash.each do |key, value|
			send "#{key}=", value # Получается как @x = 1, @y = 2
	  end
	end
end
s = Some.new x: 1, y: 2
puts s.x #=> 1
puts s.y #=> 2

# Без конструктора
class Character
  attr_accessor :strength
end
char = Character.new
char.send("strength=", 5)
p old = char.send(:strength) #=> 5
char.send("strength=", 1 + old)
p char.send(:strength) #=> 6


puts
puts '                                         define_method'

# define_method это один из параметров функции send, затем через запятую название метода, затем блок с телом метода
send :define_method, "aaa" do   # можно заменить do end  на  {}
  puts "Hello, I'm new method"
end
# вызываем метод define_method, передаем в него название "aaa" и блок, в итоге создается метод aaa с телом из блока
aaa        #=> Hello, I'm new method
send 'aaa' #=> Hello, I'm new method

# Позволяет задавать имя метода значением и например определять его из консоли при помощи gets
method = gets.strip
send(:define_method, method){ "Hello, I'm new method" }
send method # в случае с переменной вызов только через send если не в ручную

# С параметрами(передаются в блок)
send :define_method, "some" do |p1, p2|
  "params is #{p1} #{p2}"
end
p some(5, 7) #=> params is 5 7"


# Альтернативный синтаксис, в котором блок/лямбда передается как 2й параметр
meth = :one_to_five
lmbd = ->{(1..5).to_a}
define_method(meth, lmbd)
p one_to_five #=> [1, 2, 3, 4, 5]

# С параметрами
meth = :one_to_five
lmbd = ->(p1, p2){(p1..p2).to_a}
define_method(meth, lmbd)
p one_to_five(3, 8) #=> [3, 4, 5, 6, 7, 8]


puts
# Создание метода экземпляра в методе класса
class Conjurer
  # Вариант 2
  def Conjurer.conjure(name, lamb)
    send :define_method, name do
      lamb.call
    end
  end
  # Вариант 2
  def self.conjure name, lmbda
    define_method(name, lmbda)
  end
end
Conjurer.conjure(:one_to_five, ->{(1..5).to_a})
p Conjurer.new.one_to_five #=> [1, 2, 3, 4, 5]


puts
puts '                                         Установка атрибутов'

# Установим переменные экземпляра при помощи instance_variable_set и геттеры и сеттеры для них при помощи send

class GenericEntity
  def initialize(hh)
    hh.each do |k, v|
      instance_variable_set("@#{k}", v) # создание переменной экземпляра с именем ключа и значением value
      self.class.send(:attr_accessor, k) # отправляем классу нашего объекта(тоесть используем send для метода класса attr_accessor) имя метода и устанавливаем в него значение k установленное выше именем переменной
    end
  end
end

box = GenericEntity.new(:shape => "square", :material => "cardboard")
p box.material #=> "cardboard"
box.material = 2
p box.material #=> 2













#
