puts '                                         ООП: Module/namespace(Модули)'

# В модуль можно помещать attr_ ...  - проверить

# class Admin::UsersController < ApplicationController   синтаксис создания модуля сразу с созданием класса (проверить)

# module == namespace == пространство имён

# Модули — это способ группировки методов, классов и констант; своего рода новый уровень логического разделения программы после классов и методов. Модуль может содержать любок количество методов, классов и других модулей

# Модули дают преимущества:
# 1. Модули предоставляют пространство имен и предотвращают конфликты имен.(В разные модули можно поместить константы и методы с одинаковыми именами и тогда они никак не будут конфликтовать в основном коде.)
# 2. Модули реализуют возможность миксина.
# 3. Модули позволяют удобно помещать различные методы в отдельный фаил.

# Имена(константы) модуля записываются так же, как константы класса, с начальной прописной буквы. Определения методов также выглядят одинаково: методы модуля определяются точно так же, как методы класса.

# ПРИМЕЧАНИЕ: Предпочитайте модули классам содержащим только методы класса. Классы следует использовать только тогда, когда имеет смысл создавать из них экземпляры.

# Это ....
include A
B.new
# тоже самое что и ...
A::B.new
#  ??

# Это алиасы или есть разница ??
include Tools
extend Tools


puts
puts '                                       Вызов методов и констант из модуля'

# Методы записанные с префиксом или под module_function не могут запускаться без префикса модуля, в то время как записанные без префикса могут и так и так

module Amodule # Модуль создается при помощи ключевого слова module, название модуля с большой буквы
  # Константа
  PI = 3.14

  # Вызов методов из модуля способ 1: Название методов должно иметь префикс с именем модуля либо префикс self, аналогично методам класса. Эти методы будут методами модуля(вызываться от модуля)
  def Amodule.module_meth1(par)
    par - 1
  end
  def self.module_meth2(par)
    par - 5
  end

  # Вызов методов из модуля способ 2: Можно не добавлять имя модуля префиксом к названию метода(в теле модуля), но тогда перед вызовом метода нужно воспользоваться оператором вызова модуля "include Modulename"
  def somemeth(par)
    par + 1
  end

  # Вызов методов из модуля способ 3: при помощи ключевого слова module_function, которое указывает на то, что нижестоящие методы являются методами модуля.
  module_function

  def shout(whatever)
    whatever.upcase
  end
end
# Константа/класс модуля вызывается аналогично тому как вызывается константа класса, через ::
p Amodule::PI #=> 3.14

# Вызов методов из модуля способ 1:
p Amodule.module_meth1(5) #=> 4
p Amodule.module_meth2(20) #=> 15
p module_meth2(20) #=> 15  # undefined method `module_meth2' for main:Object (NoMethodError)

# Вызов методов из модуля способ 3:
p Amodule.shout('Hello') #=> "HELLO"  # метод является методом модуля тк стоит ниже module_function
p shout('Hello') #=> "HELLO" # undefined method `shout' for main:Object (NoMethodError)

# Вызов методов из модуля способ 2:
p Amodule.somemeth(5) #=> undefined method `somemeth' for Amodule:Module (NoMethodError)
# Для того чтобы методы вызывались подключим модуль в этом фаиле:
include Amodule # !!! модуль подключается в области ниже этой строки но не выше
# Теперь мы можем вызвать метод не содкржащий префикса с именем модуля
p Amodule.somemeth(Amodule::PI + 7) #=> 11.14  # Вызов метода модуля с помещением константы в параметр
# В том числе и без указания префикса если нет конфликта имен
p somemeth(Amodule::PI + 7) #=> 11.14  # Вызов метода модуля с помещением константы в параметр
# Методы с префиксом нельзя без него вызвать и при подключенном модуле
p module_meth1(5) #=> undefined method `module_meth1' for main:Object (NoMethodError)
p PI # если модуль подключен то можем вызвать константу/класс без Amodule::


puts
puts '                                   Пространство имен. Конфликты имен'

# Мы можем определить еще один модуль с тем же именами функции, что и у модуля выше, но с другой функциональностью и конфликта в программе не возникнет изза того что этот метод будет методом другого модуля:
module Bmodule
  PI = 5
  def Bmodule.module_meth1(par)
    par + 10
  end
  def somemeth(par)
    par + 11
  end
end
p Bmodule::PI #=> 5   # Не возникает конфлика при вызове констант с одинаковым именем и разными значениями из разных модулей
p Bmodule.module_meth1(Amodule::PI/4) #=> 10.785    # Используем константу одного модуля в методе другого
p PI #=> 3.14   вызвалась константа модуля Amodule, тк он подключен а Bmodule нет
p somemeth(1) #=> 2   вызвался метод модуля Amodule, тк он подключен а Bmodule нет
include Bmodule
p PI #=> вызвалась константа модуля Bmodule, видимо потому что он бы подключен познее и переопределил константу для этой области
p somemeth(1) #=> 12   вызвался метод модуля Bmodule так же как с константой


puts
puts '                       require и require_relative(подключение модуля из другого фаила)'

# Создаем для модуля новый фаил(e26_tools.rb) и создаем в нем модуль

# require и require_relative - операторы загружающие фаил с модулем чтобы использовать какой-либо определенный модуль


# require_relative - загружает файл с указанным путём относительно текущего файла
require_relative "./main/e26_tools" # "Подключение" фаила. Если фаил с модулем и данный фаил в одной папке то путь не прописываем, а иначе необходимо указывать путь
Tools.say_hello("George") #=> "Hi, George"
include Tools # Подключаем теперь сам модуль
extend Tools # альтернатива include ??
say_bye("Вася") #=> 'Bye, Вася'


# require - ключевое слово для подключения фаила, оно использует для загрузки набор каталогов, заданных настройками среды и параметрами запуска интерпретатора
require './main/e26_tools' #=> .rb писать необязательно
# './' - текущая директория и далее путь к этому фаилу
# Можно подключить "$LOAD_PATH << '.'" чтобы искать фаилы в текущем каталоге
BB.say_hi #=> "hi"


puts
puts '                                           Классы из модулей'

# ::  - Синтаксис обращения к классу через модуль аналогичен синтаксису обращения к константе
module Humans
	class JessiePinkman # классов в модуле может быть сколько угодно.
		def say_hi
			puts 'hi, bitch'
		end
	end
end
jessie_pinkman = Humans::JessiePinkman.new
jessie_pinkman.say_hi #=> "hi, bitch"


puts
puts '                                        Подключение модуля в класс'

# Подключение модуля в класс вне тела класса
Array.include SelfInject


# Чтобы встроить модуль в класс, используется оператор include в теле класса:
module Week
  FIRST_DAY = "Sunday"
  def Week.weeks_in_month
    puts "You have four weeks in a month"
  end
  def Week.weeks_in_6_month
    puts "You have 26 weeks in a month"
  end
  def weeks_in_year
    puts "You have 52 weeks in a year"
  end
end

class Decade
  include Week # Подключаем модуль в теле класса, теперь все что содержит модуль доступно в классе

  def no_of_months
    puts "120 months from #{FIRST_DAY}" # Константа модуля вызвана в методе класса
  end
  def weeks_in_month  # Так можно вызвать метод модуля от объекта
    Week.weeks_in_month
  end
end
d1 = Decade.new
# Константу можно вызвать и от модуля и от класса в который он подключен:
p Week::FIRST_DAY #=> "Sunday"
p Decade::FIRST_DAY #=> "Sunday"
# Метод класса с подключенной константой модуля:
d1.no_of_months #=> "120 months from Sunday"

# Вызов методов от объекта(методы модуля без префикса имени модуля при подключении в класс работают как методы класса):
d1.weeks_in_year #=> "You have 52 weeks in a year"
d1.weeks_in_6_month #=> undefined method `weeks_in_6_month' for #<Decade:0x00000268d5584950> (NoMethodError)  # Нельзя вызвать от объекта метод модуля с префиксом инмени модуля.
# Чтобы вызвать такой метод из объекта нужно будет поместить Week.weeks_in_month в метод класса
d1.weeks_in_month #=> You have four weeks in a month

# Метод модуля с префиксом нельзя вызвать от объекта класса или как метод класса, а можно только от модуля
d1.weeks_in_6_month #=> undefined method `weeks_in_6_month' for #<Decade:0x000001f507519660> (NoMethodError)
Decade.weeks_in_6_month #=> undefined method `weeks_in_6_month' for Decade:Class (NoMethodError)


puts
# Подключение атрибутов и конструктора в класс из модуля:
module MyModule
  attr_accessor :x

  def initialize(options = {})
    @x = options[:x] || 0
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

  def label # Собственный метод
    '@'
  end
end

dog = Dog.new x: 10
# Используем атрибуты и конструктор из модуля
p dog.x #=> 10
p dog.x = 7 #=> 7
# Используем методы из модуля
p dog.right #=> 8
p dog.left #=> nil # Метод переопределен в классе и значение переменной y не меняется
p dog.x #=> 8  # Значение y осталось прежним


puts
puts '                                          Наследование из модуля'

class Client < ActiveRecord::Base
end


puts
puts '                                  Mix-ins/Примеси(Подключение 2+ модуля в класс)'

# Миксины в значительной степени устраняют необходимость в множественном наследовании, которое не поддерживается Руби

# Класс Sample может испльзовать методы из модулей A и B(наследуется от обоих модулей), соответсвенно можно сказать, что класс Sample показывает множественное наследование или примесь:
module A
  def a1
    puts 'a1'
  end
end

module B
  def b1
    puts 'b1'
  end
  def b2
    puts 'b2'
  end
end

class Sample
  include A # Подключаем 1й мродуль в класс
  include B # Подключаем 2й мродуль в класс
  def s1
    puts 's1'
  end
end

samp = Sample.new
samp.a1 #=> "a1"  # Вызов объектом метода из модуля A
samp.b1 #=> "b1"  # Вызов объектом метода из модуля B
samp.b2 #=> "b2"
samp.s1 #=> "s1"













#