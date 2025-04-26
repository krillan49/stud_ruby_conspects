puts '                                    Динамическое создание классов'

# Class.new - создает анонимный класс, объект класса Class который можо передать в переменную
klass = Class.new
p klass     #=> #<Class:0x000002808d610c00>
p klass.new #=> #<#<Class:0x0000023ab91575e8>:0x0000023ab9156738>


# Можно задть имя созданному классу (тоесть сделать уже не анонимным) либо присвоив класс в константу, любым удобым способом
Object.const_set('SomeKlass', Class.new)
SomeKlass2 = Class.new
# Проверим созданные классы через их объекты
p SomeKlass.new  #=> #<SomeKlass:0x0000029310b0afe0>
p SomeKlass2.new #=> #<SomeKlass2:0x000002930ea20668>



puts '                                Динамическое создание классов-наследников'

# 1. Динамическое создание класса, наследующего у другого класса
class Some
  attr_reader :some
  def initialize
    @some = 0
  end
  def Some.meth
    'Meth of Some class'
  end
end

# Аналог 'class Some2 < Some'
Some2 = Class.new(Some)
p Some2.new        #=> #<Some2:0x0000018f977de588 @some=0>
p Some2.superclass #=> Some

p Some2.meth #=> "Meth of Some class"    # унаследовал статический метод
some2 = Some2.new
p some2.some #=> 0                       # унаследовал метод экземпляра

# Длее так же можно создать наследника уже класса Some2
Some3 = Class.new(Some2)
p Some3.meth #=> "Meth of Some class"

# Все тоже с анонимным классом
some_4 = Class.new(Some2)
p some_4.meth #=> "Meth of Some class"


# 2. Динамическое создание класса с подключенным в него модулем
module SomeModule
  def some
    'Some!'
  end
end

SomeClass = Class.new { include SomeModule }

p SomeClass.new.some #=> "Some!"



puts '                       Создание классов содержащих методы, конструктор и атрибуты'

# При создании класса создаем и методы в нем при помощи передачи их в блок
klass = Class.new(Object) do

  # Можно создать конструктор
  def initialize(param)
    @param = param
  end

  # Можно создать метод экземпляра сандартно
  def some
    'hi'
  end

  # Можно создать метод экземпляра через define_method
  define_method(:plus_one) do |n|
    @param + n
  end

  # Можно создать сеттер
  define_method('some_seter=') {|val| val }

  # Можно создать ?статический? метод
  define_singleton_method(:upcase_method) { |param| param.upcase }
end

# Присваиваем имя классу
Object.const_set('Klass1', klass)

obj = Klass1.new(6)

p obj.some                    #=> "hi"
p obj.plus_one(10)            #=> 16
p obj.some_seter = 9000       #=> 9000

p Klass1.upcase_method('aaa') #=> "AAA"



puts '                              Динамическое создание классов внутри классов'

# Можно создавать так классы и внутри класса()
class Ozer
  attr_reader :a
  def initialize
    @a = 0
  end
  def Ozer.meth
    'Meth of Ozer class'
  end

  Ozer2 = Class.new(self) # можно и через self тк в области видимости класса это константа класса
  Ozer3 = Class.new(Ozer2)
end

p Ozer::Ozer2.meth #=> "Meth of Ozer class"
ozer2 = Ozer::Ozer2.new
p ozer2.a #=> 0

p Ozer::Ozer3.meth #=> "Meth of Ozer class"
ozer3 = Ozer::Ozer3.new
p ozer3.a #=> 0



puts '                                              Struct'

# Struct - класс при помощи которого удобно создавать "на лету" классы, со свойствами, геттерами и сеттерами

hh = {a:1, b:2, c:3}

new_klass = Struct.new(*hh.keys, keyword_init: true)

obj = new_klass.new(hh)

p obj   #=> #<struct a=1, b=2, c=3>
p obj.c #=> 3
obj.c = 9000
p obj.c #=> 9000















#
