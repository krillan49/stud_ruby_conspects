# respond_to_missing?   - что это за метод ??

puts '                                          method_missing'

# method_missing (резервированное название метода) принимает значение при обращении к несуществующему методу класса, значением будет имя этого несуществующего метода

# Любые неинициализированные переменных в методах экземпляра будут восприниматься как методы и вызывать method_missing

class Something
  def method_missing(name, *args)  # В method_missing обязательно указывать как минимум один параметр в который присвоится имя метода, остальные параметры(по желанию) принимают параметры из оператора несуществующего метода
    [name, *args]
  end
end
s = Something.new
p s.abcd1234 #=> [:abcd1234] # abcd1234 передается значением в параметр метода method_missing в виде символа
p s.hgfhgfg(1, 2, 3) #=> [:hgfhgfg, 1, 2, 3]


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

  def method_missing name
    puts @actions[name] ? "If you want to #{name}, you must call #{@actions[name]}" : 'No instructions'
  end
end
a = Albuquerque.new cook: 'Walt', take_a_ride: 'Jessie', die: 'Gus' # Легко будет добавить новые "методы", просто добавив значения в хэш
a.cook #=> "If you want to cook, you must call Walt"
a.take_a_ride #=> "If you want to take_a_ride, you must call Jessie"
a.die #=> "If you want to die, you must call Gus"
a.hhgl #=> "No instructions"


puts
# Мктод миссинг для сеттера
class Hash
  def method_missing(method, *args) # тут аргументы идут после =
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
    if method.to_s.end_with?('=')
      k = method.to_s.delete_suffix('=').to_sym
      METHODS[k] = arg
    end
    METHODS[method]
  end
end

Code.a = 10
p Code::METHODS #=> {:a=>10}
p Code.a #=> 10


puts
puts '                                            const_missing'

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
  def self.const_missing(sym)
    sym
  end
end
p C::B #=> :B

# создание новой константы при помощи const_missing и const_set
module M2
  def self.const_missing(name)
    const_set name, "Hellow, im #{name}"
  end
end
p M2::AA #=> "Hellow, im AA"


puts
puts '                                     Метод call. Chain adding function'

# var1
class Fixnum # класс можно например Integer в зависимости от того какие значения
  def method_missing(method, par)
    # p method #=> :call #=> :call # method по умолчанию(если после точки ничего неn) имеет значение :call
    # p n #=> [2] #=> [3]
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


#var3 (как это работает нихера не понятно)
def add(n)
  def call(m)
    self + m
  end
  n
end
















#
