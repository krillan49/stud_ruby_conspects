# ?? class Admin::UsersController < ApplicationController  ?? хз что это

# В модулях тоже можно создавать приватные методы



puts '                                        Module / namespace'

# Модуль / namespace / пространство имён — это способ группировки методов, классов и констант; новый уровень логического разделения программы после классов и методов. Модуль может содержать любое количество методов, классов и других модулей.

# ! `Module` является суперклассом для `Class`.  Это означает, что все методы, доступные для `Module`, также доступны для `Class`

# Классы - это шаблоны по которым создаются объекты, а модули - это некий набор методов который, как правило, подключается внутри класса через include/prepend/extend (в зависимости от того как именно мы хотим наследоваться что-либо с модуля)

# Предпочитайте модули классам содержащим только методы класса. Классы следует использовать только тогда, когда имеет смысл создавать из них экземпляры.

# Модули дают преимущества:
# 1. Предоставляют пространство имен и предотвращают конфликты имен. В разные модули можно поместить константы и методы с одинаковыми именами и тогда они никак не будут конфликтовать в основном коде
# 2. Удобно создавать набор методов и подключать их в разные области, например в классы
# 3. Реализуют возможность миксина.
# 4. Можно использовать для своей библиотеки, выбрав уникальное имя модуля(лучше придумать необычное, чтоб не попасть на такое же, можно проверить в поиске рубиджемс, тк обычно имена модулей и название гемов одинаковое)

# Модуль создается при помощи ключевого слова module, название модуля с большой буквы

# Модули можно подключать в классы или в другие модули



puts '                                  Модули и нэйминг директорий проекта'

# Обычно принято, что именем модуля называют директорию, в которой лежит фаил с модулем и вложенным классом(или модулем), а имя этого фаила называют так же как вложенный класс/модуль. Тоесть в разных фаилах одной директории вложено в модули с одинаковым именем:

# my_gem.rb         -> MyGem
# my_gem/foo.rb     -> MyGem::Foo
# my_gem/woo/zoo.rb -> MyGem::Woo::Zoo



puts '                                  Подключение модуля из другого фаила'

# Желательный подход - 1 фаил для одного модуля/класса

# Создаем для модуля новый фаил(tools/modules.rb) и создаем в нем модули

# require_relative
require_relative "tools/modules.rb"
Tools.say_hello("George") #=> "Hi, George"
include Tools # подключаем теперь модуль
say_bye("Вася")           #=> 'Bye, Вася'

# require
require './main/OOP/tools/modules.rb'
BB.say_hi     #=> "hi"
include BB
say_bye_bye() #=> "Bye bye"



puts '                              Константы модуля и методы для работы с ними'

# Константы и модуля определяются точно так же, как и константы класса.
module MyModule # Модуль создается при помощи ключевого слова module, название модуля с большой буквы
  PI = 3.14

  # const_set(name, value) - (? альтернатива стандартной инициализации ?) метод устанавливает константу с указанным именем (`name` - символ или строка) и значением (`value`) внутри модуля
  const_set(:MY_CONSTANT, 10)
end

module ChildModule # Модули можно подключать в другие модули
  include MyModule
end

# Константа модуля вызывается через '::' это значит, что внутри модуля нужно найти(вызвать из модуля) константу с этим названием
p MyModule::PI           #=> 3.14
p MyModule::MY_CONSTANT  #=> 10

# const_get(name) - возвращает значение константы с указанным именем (`name`).  Выбрасывает `NameError`, если константа не определена.
p MyModule.const_get(:PI)          #=> 3.14
p MyModule.const_get(:MY_CONSTANT) #=> 10

# constants(inherit = true) - возвращает массив символов, представляющих имена всех констант, определенных в модуле (и, опционально, в его предках)
p MyModule.constants  #=> [:PI, :MY_CONSTANT]

# const_defined?(name, inherit = true) - возвращает `true`, если константа с указанным именем (`name`) определена в модуле или в его предках (если `inherit` равно `true`).  Если `inherit` равно `false`, проверяется только текущий модуль.
p ChildModule.const_defined?(:MY_CONSTANT)        #=> true
p ChildModule.const_defined?(:MY_CONSTANT, false) #=> false

# При подключении модуля через include можно вызвать константы без '::'
include MyModule
p PI           #=> 3.14
p MY_CONSTANT  #=> 10



puts '                                       Методы "экземпляра" модуля'

# Методы "экземпляра" в модуле определяются точно так же, как в классе

# Модуль может использовать attr_ конструкции тоесть создает соответсвующие методы

# Перед вызовом метода "экземпляра" модуля, обязательно нужно воспользоваться оператором вызова модуля "include", после этого могут быть вызваны как от префикса модуля так и без него

module MyModule2
  attr_accessor :aaa

  def somemeth(par)
    par + 1
  end
end

# Вызов стандартных методов модуля - необходимо использовать include, можно вызывать как от константы модуля, так и без нее
p MyModule2.somemeth(5) #=> undefined method `somemeth' for Amodule:Module (NoMethodError)

include MyModule2 # !!! модуль подключается в области ниже этой строки но не выше

# Теперь можно вызвать методы "экземпляра" модуля
p somemeth(5)           #=> 6
p MyModule2.somemeth(2) #=> 3

# attr_
MyModule2.aaa = 'x'
p MyModule2.aaa         #=> 'x'



puts '                                       Статические методы модуля'

# Статические методы модуля определяются точно так же, как статические методы класса.
# Статические методы модуля внутри себя вызывают по умолчанию только статические методы модуля так же как и классы

# Методы определенные в модуле как статические при помощи префикса не могут запускаться без префикса модуля, но им не нужно подключение через "include", а методы определенные при помощи module_function ? объединяют свойства статических и не статических методов, и потому могут запускаться от префикса без "include" и как с префиксом так и без при подключении черех "include"

module MyModule3
  # 1. Название статических методов должно иметь префикс с именем модуля, аналогично методам класса.
  def MyModule3.module_meth1(par)
    par - 1
  end

  # 2. Название статических методов должно иметь префикс с self, аналогично методам класса.
  def self.module_meth2(par)
    par - 5
  end

  # 3. module_function - делает методы модуля доступными как private методы экземпляра и как статические методы модуля. Создает копию указанного метода (или методов, если указано несколько) и вставляет её как *private* метод экземпляра модуля. Оставляет исходный метод как статический метод модуля.

  # если module_function не принмает параметров, то определяет все нижестоящие методы
  module_function

  def shout(whatever)
    whatever.upcase
  end

  # если module_function принмает параметры, то определяет методы одноименные параметрам
  def some_method
    puts "MyModule.static_method called"
  end
  
  module_function :some_method
end

# Вызов статических методов из модуля осуществляется без подключения через include, от константы модуля
p MyModule3.module_meth1(5)  #=> 4
p MyModule3.module_meth2(20) #=> 15
p MyModule3.shout('Hello')   #=> "HELLO"

# Статические методы определенные с префиксом  нельзя вызвать без префикса вне зависимости от того подключен модуль или нет
p module_meth2(20)         #=> undefined method `module_meth2' for main:Object (NoMethodError)
p shout('Hello')           #=> undefined method `shout' for main:Object (NoMethodError)
include MyModule3
p shout('Hello')           #=> "HELLO"
p module_meth2(20)         #=> undefined method `module_meth2' for main:Object (NoMethodError)



puts '                                   Пространство имен. Конфликты имен'

# Можно определить несколько модулей с одинаковыми именами методов и констант и конфликта в программе не возникнет изза того, что эти методы будут вызваны от разных модулей:

module Amodule
  PI = 3.14
  def Amodule.module_meth1(par)
    par + 5
  end
  def somemeth(par)
    par + 6
  end
end

module Bmodule
  PI = 5
  def Bmodule.module_meth1(par)
    par + 10
  end
  def somemeth(par)
    par + 11
  end
end

include Amodule

p Bmodule::PI #=> 5   # Не возникает конфлика при вызове констант с одинаковым именем из разных модулей
p Bmodule.module_meth1(Amodule::PI/4) #=> 10.785    # Используем константу одного модуля в методе другого

p PI          #=> 3.14   # вызвалась константа модуля Amodule, тк он подключен а Bmodule нет
p somemeth(1) #=> 7      # вызвался метод модуля Amodule, тк он подключен а Bmodule нет

include Bmodule

p PI          #=> 5      # вызвалась константа от Bmodule, тк он подключен ниже и переопределил константу для этой области
p somemeth(1) #=> 12     # вызвался метод модуля Bmodule так же как с константой



puts '                                           Классы из модулей'

# Если подключить одинаковые константы из модуля при помощи include, то будет применяться последняя, тк она получится записанной позже и переопределит предыдущую. Потому в таких случаях лучше использовать синтаксис "::"

module Humans
	class JessiePinkman # классов в модуле может быть сколько угодно.
		def say_hi
			'hello'
		end
	end
end

module Dillers
	class JessiePinkman
		def say_hi
			'hi, bitch'
		end
	end
end

# ::  - Синтаксис обращения к классу через модуль аналогичен синтаксису обращения к константе, это значит, что внутри модуля нужно найти(вызвать) константу с этим названием
jessie_pinkman = Humans::JessiePinkman.new
jessie_pinkman2 = Dillers::JessiePinkman.new

# Теперь это объекты разных классов и соотв будут обращаться к своим отдельным методам
p jessie_pinkman.say_hi  #=> "hello"
p jessie_pinkman2.say_hi #=> "hi, bitch"



puts '                                     include, prepend и extend'

# include, prepend и extend - операторы подключения модуля по его константе, переданной как параметр в ту область видимости, в которой этот оператор записан, все содержимое модуля как бы копируется в эту точку. При подключении вне класса эти 3 метода работают одинаково, но различаются при подключении в классы

# Чтобы встроить модуль в класс или в модуль нужно:
# a) Операторы include, prepend или extend прописываются в теле класса
# b) При помощи синтаксиса ClassName.include ModuleName, ClassName.prepend ModuleName или Class.extend ModuleName записанного под классом или модулем в который подключаем модуль

# include, prepend и extend сами по себе не позволяют напрямую переносить статические методы модуля в статические методы класса (способы обхода этого ниже), они переносят в классы только костанты (include, prepend) и методы экземпляра модуля (все) как методы экземпляра класса (include, prepend) или как статические методы класса (extend)

# include и extend можно подключить в рамках одного класса, тогда создаст и методы экземпляра и методы класса, но обычно так не делают


# Модуль подключим далее в классы
module MyModule
  K = 'k'
  def meth
    'aaa'
  end
  def self.meth2
    'bbb'
  end
  def hello
    "Hello MyModule"
  end
end


# 1. include(*modules) - включает указанные модули (`modules`) в текущий модуль или класс. Иерархия наследования обновляется (модули добавляются в список предков).
# a) Константы модуля становятся доступными как константы класса (или модуля), в который включается (как если бы они были определены непосредственно в нем)
# b) Методы экземпляра становятся модуля доступными как методы экземпляра класса (или модуля), в который включается (как если бы они были определены непосредственно в нем).
# c) Не делает статические методы модуля доступными ни как статические методы класса ни как методы экземпляра класса

class ClassI
  include MyModule

  def hello # тк модуль подключен через include то одноименный метод и модуля будет переопределен данным
    "Hello ClassI"
  end
end

p ClassI::K #=> "k"

obj = ClassI.new
p obj.meth  #=> "aaa"
p obj.hello #=> "Hello ClassI"

# p ClassI.meth      #=> undefined method `meth' for ClassI:Class (NoMethodError)
# p ClassI.meth2     #=> undefined method `meth2' for ClassI:Class (NoMethodError)
# p obj.meth2        #=> undefined method `meth2' for #<ClassI:0x0000027d09280978> (NoMethodError)



# 2. prepend(*modules) - полностью аналогичен `include`, но вставляет модули перед текущим модулем/классом в цепочке поиска методов. Это полезно для переопределения или расширения методов существующего класса/модуля без изменения исходного кода.

class ClassP
  prepend MyModule # MyModule будет перед ClassP в lookup chain (переопределяет одноименные методы ClassP)

  def hello # тк модуль подключен через prepend то этот метод будет переопределен одноименным методои из модуля
    "Hello ClassP"
  end
end

p ClassP.new.hello  #=> "Hello MyModule"


# 3. extend(*modules) - делает методы экземпляра подключаемого модуля доступными как статические методы класса (или модуля), в который включается. Не делает статические методы модуля доступным как статические методы класса. Не делаент константы модуля доступными как константы класса

class ClassE
end

ClassE.extend MyModule

p ClassE.meth   #=> 'aaa'

# p ClassE::K       #=> uninitialized constant ClassE::K (NameError)
# p ClassE.new.meth #=> undefined method `meth' for #<ClassE:0x0000021d059099e8> (NoMethodError)
# p ClassE.meth2    #=> undefined method `meth2' for ClassE:Class (NoMethodError)



puts '                          Минусы подключения через include, prepend и extend'

# Минусы подключения через include, prepend и extend для декомпозиции классов:

# 1. Когда модулей в класс подключено много, то сложно создавать новые методы в классе или подключать еще модули, тк сложно уследить за нэймингом и могут быть одноименные меоды в разных модулях или новые методы в классе с тем же именем и в итоге последний метод переопределит другие и будет путаница. Особенно плохо, когда такие методы изменяют состояние. Тоесть по сути нарушается инкапсуляция и создается большая запутанность, особенно если в методах из модуля будут использованы методы из класса или других модулей

# 2. Методы такого модуля в отрыве от другого фунционала класса могут быть не полноценны, из-за чего их невозможно тестировать отдельно и нужно либо использовать весь класс в который он подключен, либо создавать специальные тестовые классы

# 3. Тк это модуль, то у него нет конструктора и соответсвенно задание в нем каких-то значений, определяющих изначальное состояние осложнено и нужно использовать какие-то лэйзи штуки вроде ||=



puts '                            Подключение статических методов модуля в класс'

# `include`, `prepend` и `extend` сами по себе не позволяют напрямую переносить статические методы модуля в статические методы класса. Для достижения этой цели, необходимо использовать `class << self` для открытия singleton class или использовать `Module#module_function` в сочетании с `extend`.

# Для Ruby 2.0+ можно просто использовать синтаксис "module_function" в сочетании с подключением через extend
# module_function - делает методы модуля доступными как методы экземпляра и как private методы модуля. Потом можно включить модуль как обычно.
module MyModule
  def static_method
    puts "MyModule.static_method called"
  end
  module_function :static_method
end

class MyClass
  extend MyModule
end

MyClass.static_method # => "MyModule.static_method called"


# Явное включение статических методов через `class << self` обычно более предпочтительно, так как это делает намерения более ясными.
module MyModule
  def self.static_method
    puts "MyModule.static_method called"
  end

  def instance_method
    puts "MyModule#instance_method called"
  end
end

# class << self открывает singleton class (или eigenclass) экземпляра `self`. Внутри класса `MyClass`, `self` относится к классу `MyClass` (объекту класса).  Следовательно, `class << self` открывает класс, представляющий сам класс `MyClass`. Методы, добавленные в этот singleton class, становятся методами класса (статическими методами).
class MyClass

  class << self  # Open the singleton class of MyClass
    include MyModule
  end

  # Можно также определить метод-контейнер, чтобы связать функциональность без прямого включения:
  def self.another_static_method
    MyModule.static_method
  end
end

MyModule.static_method  #=> "MyModule.static_method called"
MyClass.static_method  #=> "MyModule.static_method called"
# MyClass.new.instance_method # => NoMethodError: undefined method `instance_method' for #<MyClass:0x00007fc78a88c368>



puts '                                     Подключение модуля в класс'

# Удобно как альтернатива наследованию, если есть классы в которох будет совсем немного общего функционала или классы, которые уже наследуют у каких-то классов и в них надо добавить функционал


# Подключение модуля в класс вне тела класса Так же удобно для добавления функциональности во встроенные классы
Array.include SelfInject


# Константы и статические методы модуля подключенные в класс
module Week
  FIRST_DAY = "Sunday"

  def Week.weeks_in_month
    "You have four weeks in a month"
  end
end

class Decade
  include Week # Подключаем модуль в теле класса, теперь все что содержит модуль доступно в классе

  def no_of_months
    "120 months from #{FIRST_DAY}" # Константа модуля вызвана в методе класса
  end
  def weeks_in_month  # Так можно вызвать метод модуля от объекта
    Week.weeks_in_month
  end
end

d = Decade.new

# Константу можно вызвать и от модуля и от класса в который он подключен:
p Week::FIRST_DAY   #=> "Sunday"
p Decade::FIRST_DAY #=> "Sunday"
p d.no_of_months    #=> "120 months from Sunday"     # Метод класса с константой подключенной из модуля:

# Метод модуля с префиксом нельзя вызвать от объекта класса или как метод класса, а можно только от модуля или обернув вызов этого метода модуля в метод класса:
p d.weeks_in_month      #=> undefined method `weeks_in_6_month' for #<Decade:0x000001f507519660> (NoMethodError)
p Decade.weeks_in_month #=> undefined method `weeks_in_6_month' for Decade:Class (NoMethodError)
p Week.weeks_in_month   #=> "You have four weeks in a month"
p d.weeks_in_month      #=> "You have four weeks in a month"    # вызываем метод класса который вызывает одноименный метод модуля


# В модуль можно помещать attr_ ... и конструктор и подключить их потом в класс
module MyModule
  attr_accessor :x

  def initialize(x)
    @x = x
  end

  def right
    self.x += 1
  end
  def left
    self.x -= 1
  end
end

class Dog
  include MyModule # Теперь класс получает все методы, конструктор и атрибуты из модуля

  def left # Можно переопределить методы модуля для данного класса
  end

  def label # Собственный метод класса
    '@'
  end
end

dog = Dog.new(10)
# Используем атрибуты и конструктор из модуля
p dog.x     #=> 10
p dog.x = 7 #=> 7
# Используем методы из модуля
p dog.right #=> 8
p dog.left  #=> nil # Метод переопределен в классе и значение переменной y не меняется
p dog.x     #=> 8   # Значение y осталось прежним



puts '                                  Mix-ins/Примеси(Подключение 2+ модуля в класс)'

# Миксины в значительной степени устраняют необходимость в множественном наследовании, которое не поддерживается Руби

# Класс Sample может одновремено испльзовать методы из модулей A и B, соответсвенно можно сказать, что класс Sample показывает множественное наследование или примесь:
module A
  def a1
    puts 'a1'
  end
end

module B
  def b1
    puts 'b1'
  end
end

class Sample
  include A # Подключаем 1й модуль в класс
  include B # Подключаем 2й модуль в класс
  def s1
    puts 's1'
  end
end

samp = Sample.new
samp.a1 #=> "a1"  # Вызов объектом метода из модуля A
samp.b1 #=> "b1"  # Вызов объектом метода из модуля B
samp.s1 #=> "s1"


puts
puts '                                        Наследование класса из модуля'

# Наследуем у класса Base из модуля ActiveRecord
class Client < ActiveRecord::Base
end



puts '                             Методы для получения информации о модуле'

# name - возвращает строку, содержащую имя модуля.
module MyModule
end
p MyModule.name  #=> "MyModule"


# ancestors - возвращает массив, содержащий текущий модуль и все его предки (включая включенные модули, суперклассы и т.д.).  Это полезно для понимания цепочки поиска методов.
module A
end

module B
  include A
end

class C
  include B
end

p C.ancestors #=> [C, B, A, Object, Kernel, BasicObject]


# included_modules - возвращает массив всех модулей, включенных в данный модуль с помощью `include`
module A
end

module B
  include A
end

p B.included_modules #=> [A]


# method_defined?(method_name, include_private = false) - проверяет, определен ли метод с указанным именем (`method_name` - символ или строка) в модуле. Если `include_private` равно `true`, то проверяются и private методы.

# instance_methods(include_super = true) - возвращает массив символов, представляющих имена всех доступных instance методов для объектов, которые "включают" модуль (то есть, для классов, в которые модуль был включен через `include`).  Если `include_super` равно `true`, то включаются методы из предков.

# private_constant(*names) - делает указанные константы (`names` - символы или строки) private (доступными только внутри модуля/класса).

# protected_constant(*names) - делает указанные константы (`names` - символы или строки) protected.

# public_constant(*names) - делает указанные константы (`names` - символы или строки) public.












#
