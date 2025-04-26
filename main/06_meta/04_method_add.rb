puts '                                          class_eval'

# class_eval - метод вызывается от константы класса и динамически создает в нем методы экземпляра или статические, переданные в блоке

String.class_eval do
  # Добавим метод экземпляра в класс String
  def hello
    'Hello!'
  end

  # Добавим статический метод в класс String
  def self.bay
    'Bay!'
  end
end

p "abc".hello  #=> "Hello!"
p String.bay   #=> "Bay!"



puts '                                         instance_eval'

# https://www.youtube.com/watch?v=7D9wwPniszY   1h 31m

# instance_eval - метод принимает блок с инициалищзацией методов или операторов методов и добавляет их одному конкетному объекту

class Some end
some = Some.new

some.instance_eval do  # добавляем новыые метода экземпляра в класс "String"
  def hello
    'Hello!'
  end

  def bay
    'Bay!'
  end
end

p some.hello #=> "Hello!"
p some.bay #=> "Bay!"

some2 = Some.new
# p some2.hello #=> undefined method `hello' for #<Some:0x0000022ce0bd3b48> (NoMethodError)


# Пример использования
class Recipe
  def initialize(name, &block)
    @name = name
    @ings = []
    @steps = []
    instance_eval(&block) # запускает блок и срабатывет код с переданными операторами в контексте данного объекта
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














#
