puts '                         Proc/Процедуры(потом сопоставить с тем что ниже) блоки, yield, lambda'

# Proc - процедура. Существует 3 типа процедур: анонимные методы, лямбда, блок

# 1. Анонимный метод - это функция без имени
proc = Proc.new { 'какойто_код' } # создание анонимного метода
p proc.call #=> "какойто_код"  # вызов анонимной функции

# 2. Лямбда функция - почти тоже самое что и анонимный метод

# 3. Блок кода это по сути тоже анонимная функция, только передается по другому: через yield или &block.
# Блок - это какой-то кусок кода начинающийся с ключевого слова(в зависимости от типа блока например n.times do) и заканчивающийся end
# Блоки могут быть вложенными, тоесть находиться внутри тела других блоков.

# Пример
def three_ways(proc, lambda, &block) # запрашивает proc, lambda и block
  proc.call
  lambda.call
  yield # like block.call  # puts "I'm a block, but could it be???"
  puts "#{proc.inspect} #{lambda.inspect} #{block.inspect}"
end

anonymous = Proc.new { puts "I'm a Proc for sure." }
nameless  = lambda { puts "But what about me?" }

three_ways(anonymous, nameless) do
  puts "I'm a block, but could it be???"
end
#=> I'm a Proc for sure.
#=> But what about me?
#=> I'm a block, but could it be???
#<Proc:0x0000020841c7b2f8 E:/doc/ruby_exemples/test3.rb:14> #<Proc:0x0000020841c7a768 E:/doc/ruby_exemples/test3.rb:15 (lambda)> #<Proc:0x0000020841cb33d8 E:/doc/ruby_exemples/test3.rb:17>


puts
puts '                                yield (Передача блоков в функцию/функция обратного вызова)'

# Блок - это совокупность фрагментов кода. Вы присваиваете имя блоку. Код в блоке всегда заключен в фигурные скобки ({}) или do ... end.
# Блок всегда вызывается из функции с тем же именем, что и у блока. Это означает, что если у вас есть блок с именем test , то вы используете функцию test для вызова этого блока.
block_name { # имя оператора функции в который будет присвоен этот блок
  # код блока
}

# yield - можно по смыслу перевести как вызов. Ключевое слово yield вызывает блок который мы перелаем в метод, соотв этот код помещается/выполняется в вызванном месте. (это чтото вроде способа наполнения метода не в самом теле метода а вызванное при запуске метода)
def run_5_times
	3.times do |n|
    print "#{n+1}) "
		yield # сюда вызван блок { print 'some ' }. Выполняется тело блока
    print 'new '
    yield # сюда тоже вызван блок { print 'some ' }. Можно вызывать сколько угодно раз
	end
end
run_5_times { print 'some ' } #=> 1) some new some 2) some new some 3) some new some


# альтернативный синтаксис передачи блока
def show_me_text
  print "<h1>"
  yield
  print "</h1>"
end
show_me_text do
  print "Foo!"
end
#=> <h1>Foo!</h1>


# yield с параметром. В примере ниже мы по сути напишем алгоритм для метода-цикла 5.times
def run_5_times
  x = 0
	while x < 5
		yield x, 55  # передаем параметр x в yield, а он соответсвенно передает его в переменную блока(можно передать несколько параметров) x -> i, 55 -> v
    x += 1
	end
end
run_5_times { |i, v| puts "something #{v}. index #{i}" } #=> "something 55. index 0" "something 55. index 1" ...


# Передача чисел по порядку в блок
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


puts
# Конструкция block_given? помогает не получать ошибку если блок не передан
def compute
  block_given? ? yield : 'block is not transmitted'
end
p compute { 'Block' } #=> "Block"
p compute #=> 'block is not transmitted'


puts
puts '                                 Передача параметров и блоков в функцию при помощи &'

# Если перед последним аргументом метода стоит &, то этому методу можно передать блок, и этот блок будет присвоен последнему параметру. В случае, если в списке аргументов присутствуют и *par, и &par, тогда &par должен появиться позже.
def oo(par, &block) # & указывает на то что передается блок
  block.call # содержание блока вызывается методом call
end
oo('a') { puts 'foo' } # блок передается после параметров

# &block это сокращение от {|e| block.call(e)} ??
some_meth{|e| block.call(e)} # тоже самое что и...
some_meth(&block)

# Пример. Помещаем блоки в хэш
@hh = {}
def on(par, &block)
  @hh[par] = block
end
on('a') { puts 'foo' }
on('b') { puts 'bar' }
on('c') { puts 'baz' }
@hh.each_value(&:call) #=> foo bar baz

# Пример с взаимодействием с переменной и блока(внутренный all? это метод массива)
def all? array, &block
  array.all?(&block)
end
def all? *args, &block
  args.all?(&block)
end


puts
puts '                                Блоки объявления начала и конца кода(BEGIN и END)'

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
puts '                                            lambda-функции'

# lambda-функции(так же их называют lambda-выражения) - это указатель на функцию у которой нет названия/имени
# Иногда переменным очень удобно присваивать указатели на какие либо функции(а не только на их вызов как при стандартном синтаксисе), например для того чтоб поместить в массив множество указателей на функцию и потом вызывать их.
# Указываем некой переменной на функцию при помощи ключевого слова lambda:
x = lambda {'какая-то функция'}      # Синтаксис 1
x = lambda {|a| 'какая-то функция'}  # с параметром
x = lambda do |a|                    # Синтаксис 2
  'какая-то функция'
end

# Примечание: если функция содержит более 3х операторов то принято использовать обычные функции(методы), если 2 и меньше тогда lambda-функции.

proc1 = proc { | i | i * 2 } # proc - альтернативный синтаксис лямды ???

lambda{|a| a * 4 != 0}.class #=> Proc

x.call # Вызов lambda-функции производится ключевым словом call
x.call('какое-то значение для параметра a') # Вызов с заданием значения параметра
x.('какое-то значение для параметра a') # Вызов с заданием значения параметра 2(без имени метода == метод call)
test = lambda{|x| x + 10}
p test.(5) #=> 15


# Пример использования 1:
say_hi = lambda { puts 'hi'}
say_bay = lambda { puts 'bay'}
week = [say_hi, say_hi, say_hi, say_hi, say_hi, say_bay, say_bay]
week.each{|f| f.call} #=> "hi" "hi" "hi" "hi" "hi" "bay" "bay"

# Пример использования 2:
sub_10 = lambda {|x| return x - 10} # return в lambda-функции так же необязателен как и в обычной
a = sub_10.call 1000
puts a #=> 990

# Пример использования 3(Однорукий бандит):
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

	if hh[res]
		sum = hh[res].call sum
	else
		sum = sub_5.call sum
	end
end


# Альтернативный синтаксис для lamda-выражений(с помощью символа lambda rocket):
sub_10 = -> (x) {x - 10}
a = sub_10.call 1000
puts a

# Передача аргументов через []
ff = ->(x){ x.split.map(&:to_i).inject(:*) }
p ff['1 2 3 4 5'] #=> 120


# Синтаксис передачи лямбда функций и аргументов в функцию
def compose(add, id)
  ->(*args){ add.(id.(*args)) } # *args в данном случае это 0, так что можно было написать и просто arg
  # id.(*args) => ->(a){a}  => ->(a){0}  => 0
  # add.(id.(*args)) => add.(id.(0)) => ->(a){a + 1}  => ->(a){0 + 1}  =>  1
end
add = ->(a){a + 1}
id  = ->(a){a}
p compose(add, id).(0) #=> 1
p compose(add, id) #=> #<Proc:0x0000028151244af8 E:/doc/ruby_exemples/test3.rb:3 (lambda)>


# Вызов лямбды без метода call как блока
def array_procs(arr, *pr)
  pr.each do |block|
    arr.map!(&block)
  end
  arr
end
p array_procs([1, 2, 4, 6], lambda{|i| i * 2}, lambda{|i| i + 1})# [3, 5, 9, 13]












#
