puts '                          Уровни доступа к методам: public private protected'

# class API - интерфес класса, набор публичных(доступных для использования) методов класса

# Ограничение доступа нужно(например) чтоб разбивать программу на отдельные методы внутри класса для удобства

# Ruby не применяет никакого контроля доступа к переменным экземпляра и классам.


# 1. public methods (Публичные методы) - методы которые можно вызывать напрямую, используя название метода для объекта. По умолчанию все методы относятся к public. Если было заданно ключевое слово другого уровня доступа, то чтобы дальнейшие методы были в публичном доступе нужно использовать ключевое слово public.

# 2. private methods (Частные методы) - медоды идущие после ключевого слова private, которые нельзя вызвать напрямую через их оператор. Можно вызвать только опосредованно через другой метод в классе.

# 3. protected methods (защищенные методы) -  может вызываться только объектами определяющего класса и его подклассов. Нельзя вызвать protected метод объекта непосредственно, но один объект может вызвать защищенный метод для себя или любого другого родственного объекта. В классическом ООП имеет немного другой смысл чем в Руби.


class Animal
  def initialize name
    @name = name
  end

  # По умолчанию все методы класса публичные.

  def run # Публичный метод доступен напрямую
    puts "#{@name} is runing"
  end

  private # Ключевое слово назначающее нижестоящие методы приватными

  def eat
    puts 'I am eating'
  end

  public # Ключевое слово назначающее нижестоящие методы публичными

  def jump
    eat # Можно вызвать private метод eat обратившись к нему из публичного метода jump.
    puts "#{@name} is jumping"
  end

  def say1
    puts 'hello'
  end
  def say2
    puts 'hi'
  end

  private :say1, :say2 # альтернативный синтексис для задания уровня доступа, пишется в любом месте но ниже тех методов которым задает уровень доступа

  # Далее методы public, тк вышестоящий private принмает параметры и не затрагивает методы ниже

  def eat_of(animal)
    animal.eat # Обращается к private method - eat
  end

  def stay_of(animal)
    animal.stay # Обращается к protected method - stay
  end

  def stay
    puts "#{@name} stoping"
  end

  protected :stay

  private def met(n) # синтаксис для того чтобы сделать приватным конкретный метод(не затрагивает методы ниже)
    'gfghfgfh'
  end
end

class Dog < Animal
	def initialize
		super 'dog'
	end

	def bark
    eat # можно вызывать private methods суперкласса из методов подкласса
		puts 'woof'
	end

  def dog_stay_of(animal)
    animal.stay # Обращается к protected method - stay
  end

  def wooo
    stay # protected method так же как и private и public можно вызвать из тела другого метода
    puts 'woooooo'
  end
end

animal1 = Animal.new('cat')
animal2 = Animal.new('monkey')
dog = Dog.new

# 1. public methods
animal1.run #=> "cat is runing"

# 2. private methods
# Нельзя вызвать этот метод напрямую:
animal1.eat             #=> `<main>': private method `eat' called for #<Animal:0x0000019b1af41670 @name="cat"> (NoMethodError)
animal1.say3            #=> `<main>': private method `say3' called for #<Animal:0x00000142d4548428 @name="cat"> (NoMethodError)
# Опосредованный вызов приватного метода eat из тела публичного метода jump:
animal1.jump            #=> "I am eating" "\ncat is jumping"
# private methods суперкласса могут вызываться и объктами подкласса:
dog.jump                #=> "I am eating" "\ndog is jumping"
# private methods суперкласса могут вызываться и методами подкласса:
dog.bark                #=> "I am eating" "\nwoof"
# Приватный метод не может быть вызван при помощи обращения от объекта(себя или другого):
animal1.eat_of(animal2) #=> private method `eat' called for #<Animal:0x000002403062ba48 @name="monkey"> (NoMethodError)
animal1.met(2)          #=> private method `met' called for

# 3. protected methods
# Не может быть вызван напрямую:
animal2.stay             #=> `<main>': protected method `stay' called for #<Animal: ... > (NoMethodError)
# Может быть вызван при обращении к себе или другому объекту:
animal2.stay_of(animal1) #=> "cat stoping"
# Может быть вызван от объекта класса наследника при обращении к себе или другому объекту подкласса или суперкласса:
dog.dog_stay_of(animal2) #=> "monkey stoping"
# Может быть вызван от объекта класса наследника при обращении к себе или другому объекту подкласса или суперкласса:
dog.stay_of(animal2)     #=> "monkey stoping"
dog.wooo                 #=> "dog stoping\n" "woooooo"

















#
