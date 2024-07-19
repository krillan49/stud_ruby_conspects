class Some
  attr_reader :some
  def initialize
    @some = 0
  end
  def Some.meth
    'Meth of Some class'
  end
end

# Динамическое создание класса, наследующего у другого класса аналог 'class Some2 < Some'
Some2 = Class.new(Some)
p Some2 #=> SomeClass
p Some2.meth #=> "Meth of Some class"
# Создади экземпляр
some2 = Some2.new
p some2.some #=> 0
# Можно создать наследника уже класса Some2
Some3 = Class.new(Some2)
p Some3.meth #=> "Meth of Some class"
some3 = Some3.new
p some3.some #=> 0


# хз зачем создавать класс в переменную а не в константу
a = Class.new(Some)
p #<Class:0x0000022ddd91ac50>



# Можно создавать так классы и внутри класса(можно и через self)
class Ozer
  attr_reader :a
  def initialize
    @a = 0
  end
  def Ozer.meth
    'Meth of Ozer class'
  end

  Ozer2 = Class.new(self)
  Ozer3 = Class.new(Ozer2)
end

p Ozer::Ozer2.meth #=> "Meth of Ozer class"
ozer2 = Ozer::Ozer2.new
p ozer2.a #=> 0
p Ozer::Ozer3.meth #=> "Meth of Ozer class"
ozer3 = Ozer::Ozer3.new
p ozer3.a #=> 0





# Struct класс при помощи которого удобно создавать "на лету" классы, со свойствами, геттерами и сеттерами
hh = {a:1, b:2, c:3}
new_klass = Struct.new(*hh.keys, keyword_init: true)
obj = new_klass.new(hh)
p obj #=> #<struct a=1, b=2, c=3>
p obj.c #=> 3
obj.c = 9000
p obj.c #=> 9000

# Создание анонимного класса с подключением в него модуля
Class.new { include MessagesDictionary::Injector }



# манки патчинг - добавление новых методов во встроенный класс ??

# refine - позволяет добавить функционал в существующий класс, чтобы не переоткрывать класс(тут String) на весь проект при помощи макипатчинга, а переоткрывать его только в определенном сценарии, например только для одного фаила и только там где подключен
module StringUtils
  refine String do
    def snakecase
      gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
        gsub(/([a-z\d])([A-Z])/, '\1_\2').
        tr('-', '_').
        gsub(/\s/, '_').
        gsub(/__+/, '_').
        downcase
    end
  end
end
# using - используется чтобы подключить функционал refine, тоесть тут метод snakecase добавится в класс String только там где подключаемся через using
class Config
  using StringUtils

  def initialize(klass)
    @__klass = klass.name
  end

  def file_storage
    @__klass.snakecase # теперь можем применить метод и изменить камэлкейс в снэйкккейс
  end
end
# Хорошо подходит для того чтобы не изменять встроенные классы глобально



# self.included метод который срабатывает, когда класс (тут MessagesDictionary) подключается кудато при помощи include
module MessagesDictionary
  def self.included(klass)
    # klass - принимает константу(или спец объект ??) того класса куда подключаем MessagesDictionary
    klass.include MessagesDictionary::Injector # в итоге подключим в неоходимый класс то что нам нужно
  end
end
# По аналогии с included есть и экстендед








#
