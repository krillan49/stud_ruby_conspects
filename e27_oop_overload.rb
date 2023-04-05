
puts '                                 ООП: Operator Overloading/Перегрузка оператора'

# Ruby разрешает перегрузку(переопределение) операторов, позволяя определить, как оператор должен использоваться в конкретной программе. Например, оператор "+" может быть определен таким образом, чтобы выполнять вычитание вместо сложения и наоборот. Синтаксис функций стандартный, но имя функции всегда является символом изменяемого оператора, за которым следует параметр объекта оператора. Функции оператора вызываются, когда используется соответствующий оператор. Перегрузка операторов не является коммутативной, что означает, что 3 + a не совпадает с a + 3. Когда кто-то пытается запустить 3 + a, он потерпит неудачу.
# Операторы, которые могут быть перегружены: +, -, /, *, **, %, и так далее.
# Операторы, которые не могут быть перегружены: &, &&, |, ||, (), {}, ~, и так далее.
class Car
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  # Называем метод символом того оператора который хотим переназначить(перегрузить) для данного класса
  def +(obj) # параметр принимает то что идет после оператора +, а 1е слогаемое задаем с помощью оператора self
    Car.new("#{self.name}#{obj.name}", "#{self.color}#{obj.color}") # Теперь сложение для объектов этого класса складывает названия его свойств и возвращает новый объект с полученными свойствами
  end

  def /(obj) # Теперь перегруженный оператор "/" делает тоже самое что и перегруженный ранее "+"
    Car.new("#{self.name}#{obj.name}", "#{self.color}#{obj.color}")
  end
end

a = Car.new("Mercedes", "Red")
b = Car.new("Audi", "Silver")

puts (a + b).inspect #=> #<Car:0x000000020a0620 @name="MercedesAudi", @color="RedSilver">  # Оператор ‘+’ был перегружен, таким образом, что он возвращает два конкатенированных строковых вывода name и color. Без перегрузки выдало бы ошибку - "undefined method `+' for #<Car ..."
puts (a / b).inspect #=> #<Car:0x000001e4cb66c860 @name="MercedesAudi", @color="RedSilver">


puts
# Перегрузим оператор сопоставления <=> (Если приемник меньше другого объекта, то он возвращает -1, если приемник равен другому объекту, то он возвращает 0. Если приемник больше другого объекта, то он возвращает 1.)
class ComparableOperator
  attr_accessor:name

  def initialize(name)
    @name = name
  end

  def <=>(obj) # Перегружаем оператор сопоставления для этого класса, теперь он сравнивает значения переменных объектов
    self.name <=> obj.name
  end
end

a = ComparableOperator.new("Geeks for Geeks")
b = ComparableOperator.new("Operator Overloading")

puts a <=> b #=> -1   # вывод равен -1, потому что ASCII-код "G"(ASCII = 71) меньше, чем "O" (ASCII = 79)  # без перегрузки вывелась бы пустая строка
puts "Geeks for Geeks" <=> "Operator Overloading" #=> -1  # Те сравненивает вот так.

#  (Примечание: мы также можем использовать =, ==, операторы для проверки)


puts
# Перегрузка оператора для мат опереций свойства объекта с числом:
class Tester
  attr_accessor:num

  def initialize(num)
    @num = num
  end
  # Сложение свойства объекта и числа
  def +(obj) #  В качестве параметра obj выступает число идущее после + в выводе
    @num + obj  # Свойство можно вызвать просто переменной без ссылки на объект либо при помощи self.num
  end
  # Умножение свойства объекта и числа
  def *(obj)
    @num * obj
  end
  # Возведение свойства объекта в степень числа
  def **(obj)
    @num ** obj
  end
end
a = Tester.new(5)
puts a + 3 #=> 8
puts a * 3 #=> 15
puts a ** 3 #=> 125
# (Примечание: перегрузка оператора не является коммутативной операцией, т.Е. Если бы мы использовали 3 + a вместо a + 3, мы получили бы такую ошибку: source_file.rb:17:in `+’: Тестер не может быть принужден к Fixnum (TypeError) из source_file.rb:17:в `)


puts
# Перегрузка оператора для мат опереций свойства объекта со свойством другого объекта
class Tester
  attr_accessor:num

  def initialize(num)
    @num = num
  end
  # Сложение свойств объектов
  def +(obj)
    self.num + obj.num
  end
  # Перемножение свойств объектов
  def *(obj)
    self.num * obj.num
  end
  # Возведение свойства объекта в степень свойства другого объекта
  def **(obj)
    self.num ** obj.num
  end
end
a = Tester.new(5)
b = Tester.new(4)
puts a + b #=> 9
puts a * b #=> 20
puts a ** b #=> 625
# (Примечание: оператор ‘+=’ должен быть определен через оператор +, т.Е. Нам просто нужно определить оператор ‘+’, и компилятор автоматически использует его в смысле ‘+=’)


puts
# Другие примеры(с возвратом нового объекта): Оператор + выполняет векторное сложение двух объектов с помощью +. Оператор * умножает свойства объекта на скаляр. Ннарный оператор - инвертирует свойства.
class Box
  attr_accessor :width, :height

  def initialize(w,h)
    @width,@height = w, h
  end

  def +(other)       # Возврат новго объекта со свойствами полученными сложением свойств 2х объектов
    Box.new(@width + other.width, @height + other.height)
  end

  def -@             # Возврат нового обьекта cо свойствами вызванного объекта с другим знаком
    Box.new(-@width, -@height)
  end

  def *(scalar)     # Возврат нового обьекта со свойствами вызванного объекта умноженными на число
    Box.new(@width * scalar, @height * scalar)
  end
end

a = Box.new(2, 3)
b = Box.new(4, 5)

p a + b #=> #<Box:0x000001f947805718 @width=6, @height=8>
p -a #=> #<Box:0x000001fc62045028 @width=-2, @height=-3>
p b * 10 #=> #<Box:0x000001c6b1768e18 @width=40, @height=50>


puts
# Перегрузка операторов - ссылок на элементы:
class Array_Operators
  attr_accessor:arr

  def initialize(*arr)
    @arr = arr
  end
  # Перегрузка оператоа [] для вызова от свойства объекта, значение x в который передается при вводе
  def [](x)
    @arr[x]
  end
  # Перегрузка оператоа присвоения "[] = " для вызова от свойства объекта, значения x и value в который передается при вводе
  def []= (x, value)
    @arr[x] = value
  end
  # Перегрузка оператоа << для вызова от свойства объекта, значение x в который передается при вводе
  def <<(x)
    @arr << x
    "#{@arr}"
  end
end
a = Array_Operators.new(0, 3, 9, 27, 81)
puts a[4] #=> 81
a[5] = 51
puts a[5] #=> 51
puts a << 41 #=> [0, 3, 9, 27, 81, 51, 41]
puts a[6] #=> 41


puts
puts '                                 Freezing Objects(Замораживание объектов)'

# Метод замораживания в Object позволяет нам предотвратить изменение объекта, эффективно превращая объект в константу. Любой объект можно заморозить, вызвав Object.freeze . Замороженный объект нельзя изменить: вы не можете изменить его переменные экземпляра.
# Чтобы проверить, заморожен ли данный объект, используется Object.frozen? метод, который возвращает true, если объект заморожен, в противном случае возвращается значение false.

class Box
  def initialize(w,h)
    @width, @height = w, h
  end
  # accessor methods
  def getWidth
    @width
  end
  def getHeight
    @height
  end
  # setter methods
  def setWidth=(value)
    @width = value
  end
  def setHeight=(value)
    @height = value
  end
end
box = Box.new(10, 20)
box.freeze # Замораживаем объект
p box.frozen? #=> true  # Проверяем заморожен ли объект

# accessor methods работают нормально
p box.getWidth #=> 10
p box.getHeight #=> 20

# setter methods выдают ошибку, тк объект заморожен
box.setWidth = 30 #=> `setWidth=': can't modify frozen Box: #<Box:0x0 ...
box.setHeight = 50 #=> `setHeight=': can't modify frozen Box: #<Box:0x000001 ...


puts
puts '                             Создание неинициализированного объекта(Allocate)'

# Можно создать объект, не вызывая инициализацию его конструктора(.new), при помощи суффикса allocate вместо new, который и создаст неинициализированный объект
class Box
  attr_accessor :width, :height

  def initialize(w,h)
    @width, @height = w, h
  end
  # instance method
  def getArea
    @width * @height
  end
end
# Создание объекта при помощи new:
box1 = Box.new(10, 20)
# Создание неинициализированного объекта пр помощи allocate
box2 = Box.allocate
# вызываем instance method для инициализированного объекта box1
p box1.getArea #=> 200
# вызываем instance method для неинициализированного объекта box2
p box2.getArea #=> `getArea': undefined method `*' for nil:NilClass (NoMethodError)
# вызываем свойство для неинициализированного объекта box2
p box2.width #=> nil


puts
puts '                                            Информация о классе'

# Если определения классов являются исполняемым кодом, это подразумевает, что они выполняются в контексте некоторого объекта: self должен на что-то ссылаться. #Это означает, что определение класса выполняется с этим классом в качестве текущего объекта. Это означает, что методы в метаклассе и его суперклассах будут доступны во время выполнения определения метода.
class Box
  puts "Type of self = #{self.class}" #=> Type of self = Class
  puts "Name of self = #{self.name}" #=> Name of self = Box
end
