puts
puts '                                            Метод to_s'

# В любом классе, который вы определяете, желательно иметь метод экземпляра to_s(зарезервированное слово) для возврата строкового представления объекта. Ниже приведен простой пример представления объекта Box с точки зрения ширины и высоты. Метод to_s работает только с данным зарезервированным именем, если его изменить то выдаст метаданные
class Box
  def initialize(w,h)
    @width, @height = w, h
  end

  def to_s
    "w:#@width h:#@height"  # string formatting of the object.
  end
end
box = Box.new(10, 20)

# to_s метод (!)автоматически(!) вызывается при интерполяции переменной объекта
puts "String representation of box is: #{box}" #=> String representation of box is: w:10 h:20
puts box #=> w:10 h:20
# Если метода to_s нету:
puts "String representation of box is: #{box}" #=> String representation of box is: #<Box:0x000001bf683c1b20>
puts box #=> #<Box:0x00000218c439d8f0>


puts
puts '                                 Freezing Objects(Замораживание объектов)'

# Метод замораживания в Object позволяет нам предотвратить изменение объекта, эффективно превращая объект в константу. Любой объект можно заморозить, вызвав Object.freeze. Замороженный объект нельзя изменить: вы не можете изменить его переменные экземпляра.
# Чтобы проверить, заморожен ли данный объект, используется Object.frozen? метод, который возвращает true, если объект заморожен, в противном случае возвращается значение false.

class Box
  def initialize(width)
    @width = width
  end
  def get_width # accessor method
    @width
  end
  def set_width=(value) # setter method
    @width = value
  end
end
box = Box.new(10)
box.freeze # Замораживаем объект
p box.frozen? #=> true  # Проверяем заморожен ли объект

# accessor methods работают нормально
p box.get_width #=> 10

# setter methods выдают ошибку, тк объект заморожен
box.set_width = 30 #=> `setWidth=': can't modify frozen Box: #<Box:0x0 ...


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













# 
