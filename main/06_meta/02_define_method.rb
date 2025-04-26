puts '                                         define_method'

# define_method - метод, который позволяет динамически определить новый метод. Принимает параметром название определяемого метода в виде строки или символа и блок, лямбду или прок с кодом тела метода и параметрами если они нужны

# вызываем метод define_method, передаем в него название "aaa" и блок
define_method("aaa") do   # можно заменить "do ... end"  на  "{ ... }"
  "Hello, I'm new method"
end
# в итоге создается метод aaa с телом из блока
aaa        #=> "Hello, I'm new method"
send "aaa" #=> "Hello, I'm new method"

# Параметры для генерируемого метода передатся как параметры блока
define_method(:some) { |p1, p2| "params is #{p1} #{p2}" }
p some(5, 7) #=> "params is 5 7"


# Использование лямбды вместо блока
lamb = ->{(1..5).to_a}
define_method :one_to_five do
  lamb.call # тут лямбду нужно вызвать
end
p one_to_five #=> [1, 2, 3, 4, 5]

# Cинтаксис, в котором лямбда передается как 2й параметр, что удобнее тк не нужно ее вызывать
meth = :one_to_five
lmbd = ->(p1, p2){ (p1..p2).to_a }
define_method(meth, lmbd)
p one_to_five(1, 5) #=> [1, 2, 3, 4, 5]


# define_method может быть вызван функцией send, как и любой другой метод: 1м парамертом символ :define_method, 2м параметром название определяемого метода в виде строки или символа и блок, прок или лямбда с кодом тела метода
send :define_method, "some" do |p1, p2|
  "params is #{p1} #{p2}"
end
p some(5, 7)        #=> params is 5 7"
p send 'some', 5, 7 #=> params is 5 7"

# С лямбдой
send :define_method, :one_to_five, ->{(1..5).to_a}
p one_to_five #=> [1, 2, 3, 4, 5]



puts '                                    Создание метода экземпляра'

# Создание метода экземпляра в методе класса
class Conjurer
  # Вариант 1
  def Conjurer.conjure(name, lamb)
    send :define_method, name, lamb
  end
  # Вариант 2
  def self.conjure name, lmbda
    define_method(name, lmbda)
  end
end

Conjurer.conjure(:one_to_five, ->{(1..5).to_a})
p Conjurer.new.one_to_five #=> [1, 2, 3, 4, 5]



puts '                                         Применение'

# Позволяет определять его из консоли при помощи gets
method = gets.strip
send(:define_method, method){ "Hello, I'm new method" }
send method # в случае с переменной вызов только через send


# Пример генерации методов
# Генерируем именованные методы математических операторов
%w[plus minus times divided_by].zip(%i[+ - * /]).each do |name, operator|
  define_method(name) do |digit2| # принимает цифру
    ->(digit) { digit.send(operator, digit2) } # возвращает лямду
  end
end
# Генерируем именованные методы чисел
%w[zero one two three four five six seven eight nine].zip(0..9).each do |name, digit|
  define_method(name) do |op_method = nil| # принимает метод оператора, который возвращает лямбду
    op_method&.call(digit) || digit
  end
end
p one plus five #=> 6














#
