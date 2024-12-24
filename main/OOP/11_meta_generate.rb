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
  ingredient "salt"   # передаем операторы метода с параметром в блоке
  ingredient "sugar"
  step "mix salt & sugar"
  step "throw it in the bin"
end

p first_recipe.show_result # [["salt", "sugar"], ["mix salt & sugar", "throw it in the bin"]]


puts
puts '                            Отмена определения констант, соотв и модулей и классов'

# Отмена определения модулей и классов через удаление константы их имени
Object.send(:remove_const, :SomeClassName)
Object.send(:remove_const, :SomeModuleName)


puts
puts '                                    Добавление методов класса в класс'

def add_method_to(class_name)
  class_name.class_eval do  # добавляем новый метод класса "m" в класс "String"
    def m
      'Hello!'
    end
  end
end
add_method_to(String)
p "abc".m # => "Hello!"


puts
puts '                                   Создание классов и методов в них'

# Создание класса
klass_name = 'Foo' # Имя класса просто строка
klass = Class.new(Object) # создаем сам класс, наследующий у Object ???
Object.const_set(klass_name, klass) # присваиваем имя классу

p Foo.new #=> #<Foo:0x000001951e55fde8>
p Foo.superclass #=> Object


puts
# Создание классов с методоми экземпляра и методами класса с параметрами и без
klass = Class.new(Object) do # при создании класса создаем и методы в нем при помощи блока
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












#
