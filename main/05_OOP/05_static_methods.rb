puts '                             Class Methods или статические(static) методы'

# Методы класса / статические методы - работают без привязки к какому-либо конкретному объекту, запускаются в контексте класса (в области метода класса self вернет константу класса). Доступ к методу класса осуществляется через сам класс, а не через через экземпляр класса. Часто используются для управлением всеми существующими экземплярами класса.

# Класс содержащий только статические переменные(@@) и статические методы называется статическим классом. Но делать классы только со статическими методами не рекомендуется, нужно использовать модули. Классы следует использовать только тогда, когда имеет смысл создавать из них экземпляры.



puts '                                              Синтаксис'

# Методы класса определяются и вызываютя от константы класса

class Example
  # instance method(метод экземпляра):
  def inst_meth
  end

  # class/static methods:

  # Синтаксис 1. Статический метод(метод класса) определяется префиксом с именем класса
  def Example.hi_meth
    'hi'
  end

  # Синтаксис 2. Статический метод(метод класса) определяется ключевым словом(в виде префикса) self
  def self.bay_meth
    'bay'
  end

  def self.hi_and_bay
    # В методе класса можно вызвать другие методы класса без префикса, тк эта область видимости имеет контекст класса и соответсвенно self возвращает константу этого класса
    hi_meth + ' and ' + bay_meth
  end

end

# Вызов статического метода от константы класса:
Example.hi_meth    #=> "hi"
Example.bay_meth   #=> "bay"
Example.hi_and_bay #=> "hi and bay"



puts '                                        Вызов в теле класса'

# Методы класса можно вызывать в любой точке программы, в том чмсле и в теле класса или класса наследника вне методов

class ATTR
  def self.reader(arg)
    @@over = arg
  end
end

class Vegita < ATTR
  # применим унаследованный статический метод в теле наследника
  reader 9000

  # вернем значение установленной переменной
  def its_over
    @@over
  end
end

p Vegita.new.its_over #=> 9000



puts '                                        Варианты использования'

# Например метод new является методом класса и создает новый объект, но сам по себе не связан с конкретным объектом.


# Часто используются для управлением всеми существующими экземплярами класса
class Person
  # ... Какаято реализация ...
end
Person.all             #=> "hi"    # Вернем всех людей
Person.all('moscow')   #=> "bay"   # Вернем всех людей что живут в москве
Person.highest                     # Вернем самого высокого среди всех людей


# Используется в качестве псевдоконструктора для создание объектов. Применяется когда объекты класса нужно будет задавать по параметрам отличным от изначальных:
class Shape
  attr_accessor :num_sides, :perimeter
  def initialize(num_sides, perimeter)
    @num_sides, @perimeter = num_sides, perimeter
  end
  # Методы класса которые будут возвращать заданные объекты класса(создавать новые объекты вместо прямого использования метода new), запрашивая при этом параметры отличные от тех, что запрашивает конструктор и задавая при помощи них(и/или отдельно) параметры для конструктора.
  def Shape.triangle(side_length)
    Shape.new(3, side_length * 3)
  end
  def Shape.square(side_length)
    Shape.new(4, side_length * 4)
  end
end
# Объект созданный через конструктор напрямую с обращением к конструктору(new)
figure = Shape.new(5, 50) # требует число сторон и периметр
# Объект созданный через метод класса являющийся псевдоконструктором(triangle)
figure2 = Shape.triangle(8) # требует длинну стороны
p figure2           #=> #<Shape:0x0000012fe78b8f40 @num_sides=3, @perimeter=24>
p figure2.num_sides #=> 3
p figure2.perimeter #=> 24


# Часто используются для того, чтоб разбить программу на отдельные блоки:
class RandomEngine
  def self.get_random_value
    rand(100..999)
  end
end
class GameEngine
  def self.play
    random_value = RandomEngine.get_random_value
    # ... какоето использование random_value ...
  end
end
GameEngine.play


# Используются для описания каких-то качеств, объекта переданного в метод класса в виде параметра
class Song
  attr_reader :duration
  def initialize(duration)
    @duration = duration
  end

  def Song.is_too_long?(song) # Метод получает параметром объект
    song.duration > 300
  end
end
song1 = Song.new(260)
p Song.is_too_long?(song1) #=> false
song2 = Song.new(468)
p Song.is_too_long?(song2) #=> true



puts '                                @переменные и attr_ с методами класса'

# В Ruby, класс тоже является объектом, экземпляром класса `Class`. Поэтому, когда переменная экземпляра инициализируется внутри статического метода, она привязывается к классу как к объекту - class instance variables. В контексте этого инстанса и выполняются self методы.

# Используются переменные класса (@@), если нужно разделить состояние между экземплярами и классом. Но переменные класса могут привести к трудностям при наследовании
# Используются переменные переменные экземпляра (@), инициализированные в методе класса, если нужно хранить состояние, относящееся только к классу

class MyClass
  def self.set_class_variable(value)
    @class_variable = value # переменная привязана к классу `MyClass` как к объекту. Все экземпляры класса будут разделять одно и то же значение этой переменной (хотя в данном случае они не имеют прямого доступа к ней, необходимо использовать `MyClass.get_class_variable` или `instance1.class_variable`)
  end

  def self.get_class_variable
    @class_variable
  end
end

# Создачим инстанс переменную объекта класса
MyClass.set_class_variable("CV")

# Можно вызвать ее через кастомный статический геттер
p MyClass.get_class_variable      #=> "CV"


instance = MyClass.new

# Получить @class_variable напрямую из экземпляра не выйдет:
p instance.instance_variable_get(:@class_variable) #=> nil

# Но можно создать метод для доступа к переменной класса из экземпляра
class MyClass
  def class_variable
    self.class.instance_variable_get(:@class_variable)
  end
end

p instance.class_variable #=> "CV"


# Использовать инстанс переменные в случае, когда можно передать в аргументы - плохая практика. Получается неявная передача состояния через инстанс переменные. И надо трекать в голове, что между вызовами методов они апдейтят состояние, что не очевидно, если не читать ВЕСЬ код всех методов.

# class instance variables чтобы просто передать состояние в display result. display_result можно инлайнить и избавиться от переменных, либо использовать параметры функции, чтобы передать состояние.
# Так метод становится не только более чистый, но и его становится проще переиспользовать, ибо когда все неявное состояние вынесено в аргументы функций, эти функции можно будет использовать за пределами класса, так как он становится отвязан от этих функций

class Result
  attr_reader :success, :data, :error_message

  def self.create(success, data = nil, error_message = nil)
    @success = success
    @data = data
    @error_message = error_message

    display_result
  end

  def self.success(data)
    Result.create(true, data)
  end

  def self.failure(error_message)
    Result.create(false, nil, error_message)
  end

  private

  def self.display_result
    { success: @success, data: @data || @error_message }
  end
end

p Result.success('Vasya') #=> {:success=>true, :data=>"Vasya"}
p Result.failure('Pidor') #=> {:success=>false, :data=>"Pidor"}



puts '                                    Алиас для статического метода'

# Так как `alias_method` работает только с методами экземпляра, для создания алиаса статического метода придется использовать `singleton_class` объекта класса:

class MyClass
  def self.original_method
    p "Это оригинальный метод"
  end
end

# Создание алиаса для статического метода
class MyClass
  singleton_class.send(:alias_method, :alias_method_name, :original_method)
  # :alias_method      - вызываем этот метод через send
  # :alias_method_name - 1й аргумент имя алиаса
  # :original_method   - 2й фзшумент имя изначального метода
end

# Вызов оригинального метода
MyClass.original_method   #=> "Это оригинальный метод"

# Вызов метода через алиас
MyClass.alias_method_name #=> "Это оригинальный метод"














#
