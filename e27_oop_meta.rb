puts '                                    Мета-программирование. Функция send'

# (!!! Разобрать как работает https://www.codewars.com/kata/53a8a236a9198e218d000195/train/ruby)

# send - альтернативный способ вызова функции который позволяет задавать имя метода объектом класса symbol или string, которые можно присваивать значениями в переменные или ключами в хэши
# Вызов функции при помощи send - мета-программирование.
def mm
  puts 'hi'
end
mm # Стандартный способ вызова
send :mm  # Вызов при помощи send 1й вариант
send "mm" # Вызов при помощи send 2й вариант

# Этим способом мы можем вызвать функцию вызвав ее через переменную, в том числе например пользовательским вводом:
a = gets.strip # если введем имя функции вызываемой сенд, то она будет вызвана или не будет если имя не подходит.
send a


# Передача аргументов осуществляется через запятую после имени метода
def nn par1
  puts "num #{par1}"
end
send :nn, 555 # Передаем аргумент 555
send 'nn', 555

# Передача опций(хэша)
def nm hh
  puts "x #{hh[:x]} y #{hh[:y]}"
end
nm x: 1, y: 2 # Обычный способ
send :nm, x: 1, y: 2 # Передаем хэш через send
send 'nm', x: 1, y: 2

# Для ленивого вывода(вывести не результат а лямбду из которой при желании уже потом можно будет вывести результат)
def add(a, b)
  a + b
end
def make_lazy(func , *args)
  lambda{send func, *args}
end
make_lazy :add, 2, 3

# Пример с применением метода из класса
class String
  def each_char(method)
    self.chars.map{|e| send method, e}.join
  end
end

def f(c) c.upcase end
p "hello".each_char(:f) #=> "HELLO"


# Присвоение send объекту
def dynamic_caller(obj, method)
  obj.send method
end
p dynamic_caller('zaphod beeblebrox', :upcase) #=> "ZAPHOD BEEBLEBROX"


# Пример применения для встроенных методов
action = suspects[name].include?(guess) ? :select! : :reject!
suspects.send(action){|_, chars| chars.include?(guess)}


# пример с аргументами для метода и параллельной передачей блока
class Array
  def each_count(*args, &block)
    raise ArgsBlockSametime if args! = [] and block
    if block
      self.map{|e| block.call(e)}.tally
    elsif args != []
      args[0] = args[0].to_sym
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
cities.each_count {|city| city.length % 3 == 0} # {true=>5, false=>1}
cities.each_count(:length) {|city| city.length % 3 == 0} # raise ArgsBlockSametime


# пример с передачей массива объектов и блоком для проверки
class Array
  def invoke2(name, *args, &block) # мой вариант
    res = []
    self.each do |obj|
      if block
        res << obj.send(name, *args) if block.call(obj) # блок проверяет нужно ли вызывать метод(true/false)
      else
        res << obj.send(name, *args) # вызываем метод и передаем аргументы
      end
    end
    res
  end

  def invoke(method, *args, &block)
    #self.select(&block).map{|x| x.send(method, *args)}
    select(&block).map{|item| item.send(method, *args) } # оптимальный вариант
  end
end

class ExampleItem
  def update(arg1, arg2)
    (arg1 && arg2) ? "updated" : 'wrong args'
  end
end

items = [ExampleItem.new, nil, ExampleItem.new] # массив объектов
p items.invoke(:update, "argument 1", "argument 2") {|item| item != nil} # ['updated', 'updated']


puts
puts '                                              define_method'

# define_method это один из параметров функции send, затем через запятую название метода('aaa'), затем блок
send :define_method, "aaa" do   # можно заменить do end  на  {}
  puts "Hello, I'm new method"
end
# вызываем метод define_method, передаем в него название "aaa" и блок, в итоге создается метод aaa с телом из блока
aaa #=> Hello, I'm new method  # Вызов обычный
send 'aaa' #=> Hello, I'm new method  # Вызов через send


# Позволяет задавать имя метода значением и например определять его из консоли при помощи gets
method_name = gets.strip
send :define_method, method_name do
  puts "Hello, I'm new method"
end
send method_name # в случае с переменной вызов только через send если не в ручную


puts
# определение метода(define_method) в методе класса
class Conjurer
  def Conjurer.conjure(name, lamb)
    send :define_method, name do
      lamb.call
    end
  end
end
Conjurer.conjure(:one_through_five, ->{(1..5).to_a})
Conjurer.new.one_through_five # => [1, 2, 3, 4, 5]

# Вариант 2
class Conjurer
  def self.conjure name, lmbda
    define_method(name, lmbda)
  end
end


puts
puts '                             Объявление переменной внутри класса при помощи send'

# Мета-программирование используется для инициализации свойств класса
class Something
  attr_accessor :name # Когда мы обявляем attr_accessor, то автоматически создается метод для каждой переменной с названием(в данном случае) name=
  def initialize
    send('name=', 'Mike') # Конструкция инициализации переменной, обращается к методу name= Присваивает переменной значение 'Mike'
  end
end
s = Something.new
s.name #=> "Mike"


# Объявление переменных через хэш при помощи send. Удобно использовать если нужно инициализировать много переменных.
class Some
	attr_accessor :x, :y

  # если переменных много не удобно инициализировать обычным способом, получится слишком громоздский столдец из @name = name
	def initialize hash # Потому лучше использовать хэш и send
		hash.each do |key, value|
			send "#{key}=", value # Ключ хэша именует переменную ичерез метод= присваивает в нее значение значения переданного из хэша. Получается как @x = 1, @y = 2
	  end
	end
end
s = Some.new x: 1, y: 2
puts s.x #=> 1
puts s.y #=> 2


puts
puts '                                      send для математических операторов'

# Передача оператора и присвоение send объекту
def basic_op(operator, value1, value2)
  value1.send(operator, value2)
end
p basic_op('+', 3, 2) #=> 5


puts
# с attr_accessor
class Character
  attr_accessor :strength
  def initialize
    @strength = 5
  end
end
char = Character.new
p old = char.send(:strength) # 5
p char.send("strength=", 1 + old) # 6
p char.send(:strength) # 6


puts
puts '                                      Мета-программирование. method_missing'

# method_missing(резервированное название метода) принимает значение при обращении к несуществующему методу класса, значением будет имя этого несуществующего метода
class Something
  def method_missing name  # В method_missing обязательно указывать как минимум один параметр
    puts name.class
  end
end
s = Something.new
s.abcd1234 #=> Symbol # Метода abcd1234 не существует в классе потому abcd1234 передается значением в параметр метода method_missing в виде символа :abcd1234


# Без принадлежности к классу тоже работает но с ошибкой warning: redefining Object#method_missing may cause infinite loop
def method_missing name
  puts "name #{name}"
end
abcd1234 #=> "name abcd1234"


# Применение method_missing с использованием хэша для имитации несущ методлов из ключей и значений хэша:
class Albuquerque
  def initialize actions # получает хэш
    @actions = actions
  end

  def method_missing name # получает имя метода значением в параметр
    value = @actions[name] # находит значение в хэше по имени метода если оно соответсвует какому либо ключу
    puts "If you want to #{name}, you must call #{value}"
  end
end
a = Albuquerque.new cook: 'Walt', take_a_ride: 'Jessie', die: 'Gus' #Очень легко будет добавить новые "методы", просто добавив значения в хэш
# Метапрограммирование(вызываем несуществующие методы):
a.cook #=> "If you want to cook, you must call Walt"
a.take_a_ride #=> "If you want to take_a_ride, you must call Jessie"
a.die #=> "If you want to die, you must call Gus"
a.hhgl #=> "If you want to hhgl, you must call " #Без значения в хэшн просто ничего не написалось(nil) можно установить по умолчанию puts "If you want to #{name}, you must call #{value || 'Pisya'}"


puts
# Мктод миссинг с = в названии метода( с присвоением)
class Hash
  def method_missing(method, *args) # *args то что идет после имени метода
    if method.end_with?('=') # вызываем доп метод если имя метода с =
      k = method.to_s.delete_suffix('=').to_sym # удаляем из имени метода знак =
      self[k] = args[0]
    else
      self[method]
    end
  end
end

hash = {:five => 5, :ten => 10}
p hash[:five] # 5
p hash.five # 5,

hash.fifteen = 15
p hash[:fifteen] # 15,
p hash.fifteen # 15,
p hash # {:five=>5, :ten=>10, :fifteen=>15}


puts
# с методами класса
class Num
  NUMS = {zero: 0, one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9}
  @@arr = []
  def self.to_i
    res = @@arr.join.to_i
    @@arr = []
    res
  end
  def self.method_missing(n)
    @@arr << NUMS[n]
    self
  end
end

p Num.seven.to_i # 7
p Num.one.two.three.to_i # 123


puts
# Создаем псевдометоды в хэше-константе класса
class Code
  METHODS = {}

  def self.method_missing(method, arg = nil)
    return store_attribute(method, arg) if method.to_s.end_with?('=')
    raise 'Method non exist' if !METHODS.keys.include?(method)
    METHODS[method]
  end

  private

  def self.store_attribute(method, arg)
    k = method.to_s.delete_suffix('=').to_sym
    METHODS[k] = arg
  end
end

Code.a = 10
p Code::METHODS #=> {:a=>10}
p Code.a #=> 10



puts
puts '                                            Установка атрибутов'

class GenericEntity
  def initialize(hash)
    hash.each do |k, v|
      instance_variable_set("@#{k}", v) # создание переменной экземпляра с именем ключа и значением value
      self.class.send(:attr_reader, k) # отправляем классу нашего объекта имя метода :attr_reader и устанавливаем в него значение k установленное выше именем переменной
    end
  end
end

box = GenericEntity.new(:shape => "square", :material => "cardboard")
p box.material #=> "cardboard"


puts
puts '                                              A Chain adding function'

# var1
class Fixnum # класс можно например Integer в зависимости от того какие значения
  def method_missing(method, par)
    #p method #=> :call #=> :call # method по умолчанию(если после точки ничего не) имеет значение :call
    #p n #=> [2] #=> [3]
    self + par # 3+. возвращаем сумму от которой снова может быть вызван method_missing
  end
end

def add(n) # 1. Вызывается метод "add" возвращает число (Fixnum)
  n
end

p add(1).(2).(3) # 2. возвращенное число уже от себя вызывает несуществующий метод
#=> 6


#var2
class Fixnum
  def call n  # тк метод без названия по умолчанию это call, то сразу можно его и использовать
    self + n
  end
end

def add(n)
  n
end


#var3
def add(n)
  def call(m)
    self + m
  end
  n
end


puts
puts '                                                 const_missing'

# метод const_missing работает как method_missing но только для несуществующей константы
# для модуля
module M
  def self.const_missing(sym)
    sym
  end
end
p M::A #=> :A
# для класса
class C
  def self.const_missing(sym) sym end
end
p C::B #=> :B

# создание новой константы при помощи const_missing
module M2
  def self.const_missing(name)
    const_set name, "Hellow, im #{name}"
  end
end
p M2::AA #=> "Hellow, im AA"


puts
puts '                                         instance_eval(&block)'

# https://www.youtube.com/watch?v=7D9wwPniszY   1h 31m

class Recipe
  def initialize(name, &block)
    @name = name
    @ings = []
    @steps = []
    instance_eval(&block) # както обрабатывает и запускает все переданные методы ??
  end

  def ingredient(ing)
    @ings << ing
  end

  def step(step)
    @steps << step
  end

  def show_result
    [@ings, @steps]
  end
end

first_recipe = Recipe.new('mix') do
  ingredient "salt"   # передаем вызов метода с параметром в блоке
  ingredient "sugar"
  step "mix salt & sugar"
  step "throw it in the bin"
end

p first_recipe.show_result # [["salt", "sugar"], ["mix salt & sugar", "throw it in the bin"]]


puts
puts '                                     Отмена определения модулей и классов'

# Отмена определения модулей и классов через удаление константы их имени
Object.send(:remove_const, :SomeClassName)
Object.send(:remove_const, :SomeModuleName)


puts
puts '                                     Добавление методов класса в класс'

def add_method_to(class_name)
  class_name.class_eval do  # добавляем новый метод класса "m" в класс "String"
    def m; 'Hello!'; end
  end
end
add_method_to(String)
p "abc".m # => "Hello!"


puts
puts '                                     Создание классов и методов в них'

# Создание классов
arr = [:foo, :bar, :baz]
arr.each do |sym|
  klass_name = sym.to_s.capitalize # Имя класса просто строка
  klass = Class.new(Object) # создаем сам класс???
  Object.const_set(klass_name, klass) # присваиваем имя классу
end
puts Foo.new.inspect #=> #<Foo:0x000001951e55fde8>
puts Bar.new.inspect #=> #<Bar:0x000001951e55fbb8>
puts Baz.new.inspect #=> #<Baz:0x000001951e55fa78>


puts
# Создание классов с методоми экземпляра и методами класса с параметрами и без
klass = Class.new(Object) do # при создании класса создаем и методы в нем при помощи do...end
  define_method(:some) do # создаем метод экземпляра
    'hi'
  end

  define_method(:some2) { 'hi2' } # такой синтаксис тоже норм

  define_method(:plus_one) do |param| # создаем метод экземпляра с параметром
    param + 1
  end

  define_method('some_seter=') {|val| val } # создаем сеттер

  define_singleton_method(:upcase_method) { |param| param.upcase } # создаем метод класса с параметром
end

Object.const_set('Klass1', klass) # присваиваем имя классу

p Klass1.new.some #=> "hi"
p Klass1.new.some2 #=> "hi2"
p Klass1.new.plus_one(10) #=> 11
p Klass1.new.some_seter = 9000 #=> 9000
p Klass1.upcase_method('aaa') #=> "AAA"


# создание класса с конструктором
new_class = Class.new(Object) do
  def initialize
    p "Hello"
  end
end
Object.const_set('Klass2', new_class)
new_class.new #=> "Hello"
