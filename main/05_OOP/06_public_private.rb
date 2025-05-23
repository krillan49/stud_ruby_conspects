puts '                          Уровни доступа к методам: public private protected'

# class API - интерфес класса, набор публичных(доступных для использования) методов класса

# Ограничение доступа нужно(например) чтоб разбивать программу на отдельные методы внутри класса для удобства

# Ruby не применяет никакого контроля доступа к переменным экземпляра и классам.


private attr_reader :file, :cabinet # так можно делать приватными геттеры и сеттеры ??



puts '                                     Доступ к методам экземпляра'

# 1. public methods (Публичные методы) - методы которые можно вызывать напрямую, используя название метода для объекта. По умолчанию все методы относятся к public. Если было заданно ключевое слово другого уровня доступа, то чтобы дальнейшие методы были в публичном доступе нужно использовать ключевое слово public.

# 2. private methods (Частные методы) - медоды идущие после ключевого слова private, которые нельзя вызвать напрямую через их оператор. Можно вызвать только опосредованно через другой метод в классе. Это ограничение можно оботи вызвав метод через send

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



puts '                                   Доступ к статическим методам'

# Private статические методы доступны при непосредственном вызове только внутри самого класса (и его потомков), но не доступны извне напрямую

# Можно "обойти" private-ограничение через `send`, но это считается плохой практикой и нарушает инкапсуляцию, либо через `instance_eval`

# private_class_method должен быть вызван *после* определения статического метода, иначе он не будет работать

class MyClass
  # Синтаксис 1 для объявления статического private метода в Ruby:
  private_class_method def self.my_private_method
    "Это приватный статический метод"
  end

  def self.public_method
    # Вызываем приватный статический метод в публичном статическом методе:
    internal_processing
  end

  def self.internal_processing
    "Выполнение внутренней логики класса"
  end

  # Синтаксис 2 для объявления статического private метода (Он должен быть вызван после определения метода):
  private_class_method :internal_processing

  # Внутри самого класса (или его потомков) можно вызывать через self, в остальных случаях (внутри других классов или глобально) вызываем от константы:
  def call_private_method # тут выываем из метода экземпляра от констант через self.class
    self.class.send(:my_private_method)

    # так выдаст ошибку, тк вызывается уже не в области класса, а в области экземпляра и срабатывет приватность:
    # self.class.my_private_method
  end
end

# Попытка вызова извне вызовет ошибку:
# p MyClass.my_private_method   #=> NoMethodError: private method `my_private_method' called for MyClass:Class
# p MyClass.internal_processing #=> NoMethodError: private method `internal_processing' called for MyClass:Class

# 1. Можно вызвать private_class_method от метода в том же классе (или классе наследнике)
p MyClass.public_method   #=> "Выполнение внутренней логики класса"

# 2а. send - способ вызвать напрямую через, но это не рекомендуется:
p MyClass.send(:my_private_method)   #=> "Это приватный статический метод"  (прямой вызов)
p MyClass.new.call_private_method    #=> "Это приватный статический метод"

# 2б. instance_eval - более безопасный и предсказуемый способ вызова private static метода напрямую
p MyClass.instance_eval { internal_processing }   #=> "Выполнение внутренней логики класса"  (прямой вызов)















#
