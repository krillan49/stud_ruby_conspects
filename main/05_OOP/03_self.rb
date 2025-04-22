puts '                                             self'

# self - специальная переменная указывает на тот объект, к которому относится область действия в которой вызывается self

p self       #=> main     # main - общее пространство, которое существует все всех классов
p self.class #=> Object   # те main это экземпляр класса Object

class Array
  p self       #=> Array    # в контексте класса указывает на класс (тк класс это тоже объект)
  p self.class #=> Class
  p self.name  #=> "Array"

  def second
    p self #=> [3, 4, 5]    # в контексте метода экземпляра указывает на экземпляр, который этот метод вызвал
    self.first
    first # равнозначно предыдущему (сперва интерпритатор поищет переменную first и когда не найдет будет искать метод в контексте текущего объекта, тк вызвано в методе экземпляра)
    self[1] # вернет элемент с индексом 1 массива, тк self возващает текущий объект, тот что вызвал этот метод
  end
end

[3, 4, 5].second #=> 4

def some
  p self #=> main
end
some()


# Альтернативный способ инициальзации переменной экземпляра при помощи сеттера и self
class Car
  attr_accessor :name

  def initialize(name)
    # self.name2= это вызов метода экзэмпляра name2= в котором есть соответсвующая переменная @name2
    self.name = name
  end
end



puts '                                        Чейнинг при помощи self'

# Достаточно вернуть методом экземпляра self, чтобы вернуть текущий объект и вызвать от него еще один метод экземпляра

class List
  attr_accessor :counter, :items
  def initialize
    @items = []
    @counter = 0
  end

  def add(item)
    @items << item
    @counter += 1
    self # возвращает объект от которого вызван метод
  end
end

list = List.new
p list.add(3).add(1).counter  #=> 2       #.add(1) и .counter работают корректно, тк каждый раз возвращается объект
p list.items                  #=> [3, 1]














#
