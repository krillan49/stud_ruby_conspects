puts '                                          method_missing'

# method_missing (зарезервированное название метода) - вызывается при обращении к несуществующему методу, 1м параметром принимает, в виде символа, имя вызываемого несуществующего метода, следующими значениями принимает передаваемые в несуществующий метод параметры.

# Может быть как методом экземпляра, так и статическим



puts '                                       Инстанс method_missing'

# Стоит умтывать, что неинициализированные переменные в методах экземпляра будут восприниматься как методы и потому будет вызыван method_missing, если он реализован

class Something
  def method_missing(name, *args)  # обязательно указывать как минимум один параметр в который присвоится имя метода
    [name, *args]
  end
end
s = Something.new
p s.abcd1234         #=> [:abcd1234]
p s.hgfhgfg(1, 2, 3) #=> [:hgfhgfg, 1, 2, 3]


# Из глобальной области тоже работает, но с ошибкой "warning: redefining Object#method_missing may cause infinite loop"
def method_missing name
  puts "name #{name}"
end
abcd1234 #=> "name abcd1234"


# Для сеттера
class Hash
  def method_missing(method, *args) # тут аргументы идут после =
    if method.end_with?('=')
      k = method.to_s.delete_suffix('=').to_sym # удаляем из имени метода знак =
      self[k] = args[0]
    else
      self[method]
    end
  end
end
hash = {:five => 5, :ten => 10}
p hash[:five] #=> 5
p hash.five   #=> 5
hash.fifteen = 15
p hash[:fifteen] #=> 15
p hash.fifteen   #=> 15
p hash           #=> {:five=>5, :ten=>10, :fifteen=>15}


# Применение method_missing с использованием хэша для имитации несущ методлов из ключей и значений хэша:
class Albuquerque
  def initialize actions
    @actions = actions
  end

  def method_missing name
    @actions[name] ? "If you want to #{name}, you must call #{@actions[name]}" : 'No instructions'
  end
end
a = Albuquerque.new cook: 'Walt', take_a_ride: 'Jessie', die: 'Gus' # Легко добавить новые "методы", просто добавив значения в хэш
a.cook        #=> "If you want to cook, you must call Walt"
a.take_a_ride #=> "If you want to take_a_ride, you must call Jessie"
a.die         #=> "If you want to die, you must call Gus"
a.hhgl        #=> "No instructions"



puts '                                   Статический method_missing'

class Some
  def self.method_missing(method, *args)
    [method, *args]
  end
end
p Some.wtf(42, 9000) #=> [:wtf, 42, 9000]


# Пример использования
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
p Num.seven.to_i         #=> 7
p Num.one.two.three.to_i #=> 123


# Создаем псевдометоды в хэше-константе
class Code
  METHODS = {}

  def self.method_missing(method, arg = nil)
    if method.to_s.end_with?('=')
      k = method.to_s.delete_suffix('=').to_sym
      METHODS[k] = arg
    end
    METHODS[method]
  end
end

Code.a = 10
p Code::METHODS #=> {:a=>10}
p Code.a        #=> 10



puts '                                           const_missing'

# const_missing - метод вызывается при обращении от модуля или класса к несуществующей константе этого модуля или класса. Параметром принимает имя константы в виде символа.

# Для модуля
module M
  def self.const_missing(name)
    sym
  end
end
p M::A #=> :A


# для класса
class C
  def self.const_missing(name)
    name
  end
end
p C::B #=> :B


# Создание новой константы при помощи const_missing и const_set
module M2
  def self.const_missing(name)
    const_set name, "Hello, im #{name}"
  end
end
p M2::AA #=> "Hello, im AA"



puts '                                          respond_to_missing?'

# respond_to_missing? - метод для определения, может ли объект ответить на вызов метода, который не был явно определён. Должен возвращать true или false, в зависимости от того, может ли объект обработать вызов метода. Это полезно в контексте динамического программирования и создания классов, которые могут обрабатывать вызовы методов "на лету"

# Позволяет определить поведение объекта при попытке вызвать несуществующий метод. Он используется в сочетании с method_missing. Когда вы переопределяете method_missing, рекомендуется также переопределить respond_to_missing?, чтобы обеспечить корректное поведение.

class DynamicMethodHandler
  # переопределяем метод method_missing, чтобы обрабатывать вызовы методов, начинающихся с "dynamic_"
  def method_missing(method_name, *args)
    if method_name.to_s.start_with?("dynamic_")
      "You called a dynamic method: #{method_name} with arguments: #{args.join(', ')}"
    else
      super  # Позволяет Ruby обработать стандартный method_missing, тоесть вернуть ошибку если метод не олпределен
    end
  end

  # Переопределяем метод respond_to_missing?, чтобы он возвращал true для методов, начинающихся с "dynamic_" (тк мыособым образом рбрабатывем их в method_missing)
  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("dynamic_") || super # Если метод не соответствует условиям, вызываем super, чтобы передать управление стандартному поведению Ruby
  end
end

handler = DynamicMethodHandler.new
p handler.dynamic_method_one(1, 2)    #=> You called a dynamic method: dynamic_method_one with arguments: 1, 2
# p handler.some                        #=> undefined method `some' for #<DynamicMethodHandler:0x0000023af5942b18> (NoMethodError)
p handler.respond_to?(:dynamic_method_one) #=> true
p handler.respond_to?(:some_other_method)  #=> false












#
