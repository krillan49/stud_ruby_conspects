puts '                                                Блоки'

# Блок/block - это кусок кода, что содержится между {} или do end. Нужен чтобы добавлять в методы дополнительный код
[1,2,3].each do |el|
  # block - это все что содержится между {} или do end, например тут в итераторе будет выполняться ждя каждого элемета массива
end

# Локальные переменные инициализированные в блоке, во вне его уже не будут существовать

# Блоки могут быть вложенными, тоесть находиться внутри тела других блоков.


puts
puts '                            yield (Передача блоков в функцию/Callback)'

# Callback(функция обратного вызова) - передача исполняемого кода в качестве одного из параметров другому коду. Обратный вызов позволяет в функции исполнять код, который задаётся в аргументах при её вызове


# Блоки могут быть приняты методами, например чтобы добавить какую-то логику в определенный метод.
function_name do # имя оператора метода/функции к которому будет добавлен этот блок
  # ...            код блока
end
# Таким способом передать методу можно только 1 блок


# yield - ключевое слово(на самом деле метод), он вызывает блок, который был передан в метод через пристыковывание к оператору этого метода, код из блока помещается/выполняется в месте где стоит yield.
def demo0(n1, n2)
  yield      #=> "Hello from block!"    # тоесть код из блока подставляется сюда
  sum = n1 + n2
  yield      #=> "Hello from block!"    # можно вызвать сколько угодно раз в любом месте тела метода
  sum
end
# оператор метода принимает аргументы(если они есть) и блок, но "пристыкованный блок" имеет как бы отложенное исполнение
demo0(101, 50) { puts "Hello from block!" }
# Альтернативный синтаксис передачи блока. Чтобы использовать оператор 'p' к оператору принимающему блок с синтаксисом do end нужно взять все в скобки иначе будет ошибка
p (demo0(101, 50) do
  print "Foo!"
end) #=> 151


# Передача аргументов в блок и соответсвующие параметры для yield
def demo(*args)
  args.map do |n|
    yield(n, 5) # тут подставляется блок, например { |e, num| ... }, в переменную 'e' которого передается значение 'n', а в переменную 'num' число 5, в итоге блок исполнает свой код с этими параметрами тут
  end.sum
end
p demo(101, 50, 2, 3, 5, 6, 7) { |e, num| e.even? ? e + num : e - num } #=>  169


puts
puts '                                           block_given?'

# По умолчанию будет вызвана ошибка если вызывается yield, а блок не передан
def compute
  yield
end
p compute #=> no block given (yield) (LocalJumpError)


# block_given?  - метод обределяет был ли передан блок в текущий метод. Помогает не получать ошибку если блок не передан
def compute
  if block_given?              # проверяем был ли передан блок, чтобы избежать возможной ошибки
    yield                      # теперь будет выполнено только если блок передан
  else
    'block is not transmitted' # теперь вместо ошибки получаем строку с сообщением
  end
end
p compute { 'Block' } #=> "Block"
p compute             #=> "block is not transmitted"


puts
puts '                           Передача блоков в переменную как &параметров. call'

# Если перед последним параметром метода стоит &, то этот параметр может и должен принять блок.
# & - обозначанет что в переменную передан кусок кода/блок, который может быть выполнен потом(отложенное исполнение)
# Параметр с & всегда должен быть самым последним, после параметров с * и **
def some(par, &block)
  block.call #=> 'foo'      # содержание блока подставляется/исполняется методом call
  block.call #=> 'foo'      # можно вызвать блок несколько раз
  yield      #=> 'foo'      # block.call это равнозначное действие с yield и можно их использовать в одном и том же методе
end
some('a') { puts 'foo' }


# block.call может быть удобнее чем yield, тк можно передать переменную с блоком, например в другой метод
def method1(&block)
  method2(&block) # При передаче блока в операторе другого метода, тоже нужно использовать &
end
def method2(&block)
  block.call #=> "hello from method1!"
end
method1 { puts "hello from method1!" }

def all_nums?(*args, &block)
  args.all?(&block) # передаем блок {|n| n.positive? } во встроенный метод массивов
end
p all_nums?(1, 2, 3) {|n| n.positive? } #=> true


# block.call так же как и yield может принимать аргументы
def some(n, &block)
  block.call(n, 3)
end
p some(5) { |n1, n2| n1 * n2 } #=> 15


# Пример. Помещаем блоки в хэш
@hh = {}
def on(par, &block)
  @hh[par] = block
end
on('a') { puts 'foo' }
on('b') { puts 'bar' }
on('c') { puts 'baz' }
@hh.each_value(&:call) #=> foo bar baz


puts
puts '                               Proc/Процедуры(Анонимный метод ??)'

# Процедура(Анонимный метод ??) - это в Руби блок/кусок кода который мы можем присвоить в переменную, тоесть сделать его выполнение отложенным

def method1(&block)
  p block #=> #<Proc:0x000001b6ff2263b8 E:/doc/ruby_exemples/test.rb:4>
  # E:/doc/ruby_exemples/test.rb:4  - те имеет привязку к строке кода в которой определен изначально
  p block.class #=> Proc   # тоесть блок помещенный в переменную превращается в процедуру
end
method1 { "hello from method1!" }


# Создание процедуры через класс Proc. Синтаксис соотв так же {} или do end
p = Proc.new { puts "hello from proc!" } #=> #<Proc:0x000001b8e954e3b0 E:/doc/ruby_exemples/test.rb:1>
p.call #=> hello from proc!   # тоесть код вызывается только при вызове мтодом call, те это отложенный вызов

# Создание процедуры при помощи метода proc
p2 = proc do |a, b|
  puts "hello from proc!"
  a + b
end
p p2.call(10, 20) #=> 30     # Процедура в Руби возвращает результат своей работы


# Можно передать процедуру в метод, поместив ее в обычную переменную без &, тк это уже изначально процедура - объект и образец класса Proc, а не изначально просто блок(кусок кода), превращаемый в процедуру. Преимущество процедур в том что в отличие от просто блоков метод может принимать множество процедур, тк они передаются как обычные параметры
def caller(my_proc, my_proc2) # метод может принимать множество процедур
  my_proc.call(5) + my_proc2.call(10, 20)
end
pr = proc { |n| n * 2 } # помещаем процедуру в переменную
pr2 = proc { |a, b| a + b }
p caller(pr, pr2) #=> 49


puts
puts '                                            lambda-функции'

# lambda-функции(так же их называют lambda-выражения) - это, почти тоже, что и процедура, тоже отложенный блок кода, который можно передавать в качестве аргумента или по другому - это указатель на функцию у которой нет названия/имени(Анонимный метод ??)

# Если функция содержит более 3х операторов то принято использовать обычные функции(методы), если 2 и меньше тогда lambda-функции.

# Создание лямбды через метод lambda и do end
my_l1 = lambda do |a|
  a + ' кто-то'
end
# Вызов lambda-функции производится:
p my_l1.call("hello") #=> "hello кто-то"      # 1. ключевым словом call
p my_l1.('hi')        #=> "hi кто-то"         # 2. просто точкой без имени метода что равнозначно call
p my_l1['yo']         #=> "yo кто-то"         # 3. через []

# Создание лямбды через метод lambda и {}
my_l1 = lambda {|str| str.upcase }
p my_l1.call("hello from lambda!") #=> "HELLO FROM LAMBDA!"

# Создание лямбды через синтаксис "->" (lambda rocket)
my_l2 = ->(n) { n**2 }
p my_l2.call(6) #=> 36


# Лямбду(и обычный прок) можно передать и через & как обычный блок, например для методов что ожидают именно такой передачи
def array_procs(arr, lamb)
  arr.map(&lamb)
end
p array_procs([1, 2, 4, 6], lambda{|i| i * 2}) #=> [2, 4, 8, 12]


# Пример использования 1:
say_hi = lambda { puts 'hi'}
say_bay = lambda { puts 'bay'}
week = [say_hi, say_hi, say_hi, say_hi, say_hi, say_bay, say_bay]
week.each{|f| f.call} #=> "hi" "hi" "hi" "hi" "hi" "bay" "bay"

# Пример использования 2:
sub_10 = lambda {|x| return x - 10} # return в lambda-функции так же необязателен как и в обычной
a = sub_10.call 1000
puts a #=> 990

# Пример использования 3 (Однорукий бандит):
add_10 = lambda {|x| x + 10}
add_20 = lambda {|x| x + 20}
sub_5 = lambda {|x| x - 5}
hh = {11 => add_10, 22 => add_10, 33 => add_10, 44 => add_10, 55 => add_10, 66 => add_10, 77 => add_20, 88 => add_20, 99 => add_20}
sum = 1000
loop do
	puts "sum is #{sum}"
	gets
	res = rand(100)
	puts "res is #{res}"
	sum = hh[res] ? hh[res].call(sum) : sub_5.call(sum)
end

# Пример использования 4 (С мутными цепными вызовами и вложенными лямбдами):
def compose(add, id)
  ->(*args){ add.(id.(*args)) } # *args в данном случае это 0, так что можно было написать и просто arg
  # id.(*args) => ->(a){a}  => ->(a){0}  => 0
  # add.(id.(*args)) => add.(id.(0)) => ->(a){a + 1}  => ->(a){0 + 1}  =>  1
end
add = ->(a){a + 1}
id  = ->(a){a}
p compose(add, id).(0) #=> 1
p compose(add, id) #=> #<Proc:0x0000028151244af8 E:/doc/ruby_exemples/test3.rb:3 (lambda)>


puts
puts '                                    Proc. Отличия лямбды и процедуры'

# Proc - процедура. ?? Существует 3 типа процедур: анонимные методы, лямбда, блок ??

# 1. Анонимный метод - это функция без имени
proc = Proc.new { 'какойто_код' } # создание анонимного метода
p proc.call #=> "какойто_код"  # вызов анонимной функции
# 2. Лямбда функция - почти тоже самое что и анонимный метод
# 3. Блок кода это по сути тоже анонимная функция, только передается по другому: через yield или &block.

# Лямбды и процедуры и блоки переданные через & это образцы одного класса Proc
def three_ways(proc, lambda, &block)
  p proc #=> #<Proc:0x0000020841c7b2f8 E:/doc/ruby_exemples/test3.rb:14>
  p lambda #=> #<Proc:0x0000020841c7a768 E:/doc/ruby_exemples/test3.rb:15 (lambda)>
  p block #=> #<Proc:0x0000020841cb33d8 E:/doc/ruby_exemples/test3.rb:17>
  proc.call #=> "I'm a Proc for sure."
  lambda.call #=> "But what about me?"
  yield # или block.call  #=> "I'm a block"
end
anonymous = Proc.new { puts "I'm a Proc for sure." }
nameless  = lambda { puts "But what about me?" }
three_ways(anonymous, nameless) { puts "I'm a block" }


# Лямбды отличаются от процедур в своем поведении:

# 1. Если при вызове процедуры не передать аргументы, то в их параметры назначатся значения nil. А если передать больше аргументов то они проигнорируются
p = proc { |arg1| arg1 }
p p.call #=> nil
p p.call(1, 2, 3) #=> 1
# А если тоже самое сделать с лямбдой то будет вызвана ошибка.
l = lambda { |arg1| arg1 }
p l.call #=> wrong number of arguments (given 0, expected 1) (ArgumentError)
p l.call(1, 2, 3) #=> wrong number of arguments (given 3, expected 1) (ArgumentError)


# 2. Лямбда создает свою область выдимости, а процедура нет
def demo(obj)
  puts "before obj call"
  obj.call # внутри этого вызова будет выполняться return
  puts "after obj call"
end

p = proc do
  puts "I'm inside proc!"
  return 42 # Блок или процедура вернет не в том месте где вызвана, а в том где определена, те срабатывает в контексте той области видимости в которой определена, соотв завершает и метод и всю программу тут.
end

l = lambda do
  puts "I'm inside lambda!"
  return 42 # срабатывает в контексте лямбды и завершает лямбду, соотв лямбда сосздает собственную область
end

demo(p) #=> before obj call
        #=> I'm inside proc!
demo(l) #=> before obj call
#=> I'm inside lambda!
#=> after obj call


# Тоже на примере создания внутри метода
def fuu
  f = Proc.new {return "return from foo from inside proc"}
  f.call
  "return from fuu"
end
def bar
  f = lambda {return "return from lambda"}
  f.call
  "return from bar"
end
p fuu #=> "return from foo from inside proc"
p bar #=> "return from bar"


puts
puts '                           Блоки объявления начала и конца кода(BEGIN и END)'

# BEGIN - ключевое слово/оператор объявляет блок который будет исполнен в самом начале программы
puts "This is main Ruby Program"
BEGIN {
  puts "Initializing Ruby Program" # Эта строка будет 1й в прграмме
}
#=> Initializing Ruby Program
#=> This is main Ruby Program

# END - ключевое слово/оператор объявляет блок который будет исполнен в самом конце программы
END {
  puts "Terminating Ruby Program" #  эта строка будет последней в программе
}
puts "This is main Ruby Program"
#=> This is main Ruby Program
#=> Terminating Ruby Program


puts
puts '                                              Разное'

# Блок и Enumerator. Вызов yield как метода
def sequence(&b) # передача блока в параметры
  Enumerator.new do |y|
    n = 0
    loop do
      # вариант синтаксиса 1 (не нужна передача блока в параметры)
      y << yield(n)
      # вариант синтаксиса 2 (нужна передача блока в параметры)
      y.yield b.call(n)
      n += 1
    end
  end
end
sequence{|n| n}.take_while {|n| n < 10} #=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
sequence{|n| (n * n)}.take(10) #=> [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]













#
