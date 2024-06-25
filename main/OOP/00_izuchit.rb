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














# 
