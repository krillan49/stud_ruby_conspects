puts '                                                send'

# send - осуществляет альтернативный способ вызова метода (отправка сообщений объекту), принмает имя метода в виде symbol или string. Это позволяет хранить имена метода значениями в переменных или ключами в хэши или принимать от пользователя

def mm
  'hi'
end
p mm        #=> "hi"   # Стандартный способ вызова
p send :mm  #=> "hi"   # Вызов при помощи send 1й вариант
p send "mm" #=> "hi"   # Вызов при помощи send 2й вариант


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
send :nm, x: 1, y: 2   #=> "x 1 y 2" # Передаем хэш через send
send 'nm', x: 1, y: 2  #=> "x 1 y 2"


# Вызов метода экземпляра через send
def dynamic_caller(obj, method)
  obj.send method
end
p dynamic_caller('zaphod beeblebrox', :upcase) #=> "ZAPHOD BEEBLEBROX"


# send для операторов. Передача оператора и присвоение send объекту
def basic_op(operator, value1, value2)
  value1.send(operator, value2)
end
p basic_op('+', 3, 2) #=> 5



puts '                                       Варианты применения send'

# Удобно вызывать метод, присвоенный в переменную, в том числе с пользовательским вводом:
method_name = gets.strip
send method_name


# Отмена определения констант, соотв и модулей и классов через удаление константы их имени
Object.send(:remove_const, :SomeClassOrModuleName)


# Можно использовать для ленивого вывода(вывести лямбду из которой при желании уже потом можно будет вывести результат)
def add(a, b)
  a + b
end
def make_lazy(func , *args)
  lambda { send func, *args }
end
p make_lazy :add, 2, 3       #=> #<Proc:0x00000256c34e2138 E:/doc/ruby_exemples/test3.rb:6 (lambda)>
p make_lazy(:add, 2, 3).call #=> 5


# Пример с применением внешнего метода в классе
class String
  def every_char(method)
    self.chars.map{|e| send(method, e)}.join
  end
end
def f(c)
  c.upcase
end
p "hello".every_char(:f) #=> "HELLO"


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
cities.each_count #=> {"Melbourne"=>1, "Dallas"=>2, "Taipei"=>1, "Toronto"=>1, "Kathmandu"=>1}
cities.each_count(:length) #=> {9=>2, 6=>3, 7=>1}
cities.each_count(:gsub, /[aeiou]/, 'x') #=> {"Mxlbxxrnx"=>1, "Dxllxs"=>2, "Txxpxx"=>1, "Txrxntx"=>1, "Kxthmxndx"=>1}
cities.each_count{|city| city.length % 3 == 0} #=> {true=>5, false=>1}
cities.each_count(:length) {|city| city.length % 3 == 0} #=> raise ArgsBlockSametime



puts '                                    Прямой вызов private методов'

# send может напрямую вызвать private методы
class Aaa
  private
  def aaa
    'hi'
  end
end
a = Aaa.new
p a.send(:aaa) #=> "hi"



puts '                               Создание значений атрибутов при помощи send'

# При помощи send можно динамически задать значения различных атрибутов (инициализировать переменные экземпляра) объекта object.send("#{method}=", value)

class Something
  attr_accessor :name
  def initialize
    send('name=', 'Mike') # обращается к методу name= присваиваем переменной @name значение 'Mike'
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


# Внешнее задание значений переменных помощи send (Без конструктора)
class Character
  attr_accessor :strength
end
char = Character.new
char.send("strength=", 5)
p old = char.send(:strength) #=> 5
char.send("strength=", 1 + old)
p char.send(:strength)       #=> 6



puts '                                 Динамическая установка атрибутов'

# Можно установить переменные экземпляра при помощи instance_variable_set и геттеры и сеттеры для них при помощи send

class GenericEntity
  def initialize(hh)
    hh.each do |k, v|
      instance_variable_set("@#{k}", v)  # создание переменной экземпляра с именем ключа и значением value
      self.class.send(:attr_accessor, k) # отправляем классу нашего объекта(тоесть используем send для метода класса attr_accessor) имя метода и устанавливаем в него значение k установленное выше именем переменной
    end
  end
end

box = GenericEntity.new(:shape => "square", :material => "cardboard")
p box.material #=> "cardboard"
box.material = 2
p box.material #=> 2













#
