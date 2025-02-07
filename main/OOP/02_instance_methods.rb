puts '                                  alias_method(псевдонимы методов в классе)'

# alias_method - позволяет сделать вызов одного метода разными атрибутами, названием изначального метода и новым произвольным атрибутом. Работает только с методами экземпляра

# При помощи кодового слова alias_method можно
class AtbashCipher
  def one(str)
    str[0]
  end

  alias_method :other, :one
end

a = AtbashCipher.new
p a.one('asf') #=> "a"
p a.other('asf') #=> "a"



puts '                                              Метод to_s'

# to_s (зарезервированное имя) - метод экземпляра для возврата строкового представления объекта, при применении оператора puts к объекту или интерполяции переменной объекта, метод to_s автоматически вызывается

class Box0
  def initialize(w,h)
    @width, @height = w, h
  end
end

class Box
  def initialize(w,h)
    @width, @height = w, h
  end

  def to_s
    "w:#{@width} h:#{@height} Ha-ha!"
  end
end

box0 = Box0.new(10, 20)
box = Box.new(10, 20)

puts box0 #=> #<Box0:0x00000210af1ee8a0>

puts box  #=> w:10 h:20 Ha-ha!
p "#{box}" #=> "w:10 h:20 Ha-ha!"

# Но если инспектировать без интерполяции все равно выаст обьект
p box          #=> #<Box:0x000001ccb5842730 @width=10, @height=20>
puts box + '1' #=> undefined method `+' for #<Box:0x0000027dc8bee4a0 @width=10, @height=20>















#
