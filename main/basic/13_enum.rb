puts '                                             Enumerable'

# module Enumerable - Это такой стандартный модуль, который вы можете включить в класс при помощи include, если в этом классе реализуете метод each, то все остальные 53 метода стандартных коллекций (map, reduce, select, reject и т.п.) автоматически строятся модулем Enumerable на основе одного-единственного метода each


# Метод max_by (Enumerable)
# Возвращает элементы, для которых блок возвращает максимальные значения.
# С заданным блоком и без аргумента возвращает элемент, для которого блок возвращает максимальное значение:
(1..4).max_by {|element| -element }                    # => 1
%w[a b c d].max_by {|element| -element.ord }           # => "a"
{foo: 0, bar: 1, baz: 2}.max_by {|key, value| -value } # => [:foo, 0]
[].max_by {|element| -element }                        # => nil
# С заданным блоком и заданным целочисленным положительным аргументом n возвращает массив, содержащий n элементов, для которых блок возвращает максимальные значения:
(1..4).max_by(2) {|element| -element }                 # => [1, 2]
%w[a b c d].max_by(2) {|element| -element.ord }        # => ["a", "b"]
{foo: 0, bar: 1, baz: 2}.max_by(2) {|key, value| -value }  # => [[:foo, 0], [:bar, 1]]
[].max_by(2) {|element| -element }                     # => []


# Метод each_with_object (Enumerable)
# Вызывает блок один раз для каждого элемента, передавая как элемент, так и данный объект:
(1..4).each_with_object([]) {|i, arr| arr.push(i**2) } # => [1, 4, 9, 16]
p [1, 2, 3].each.with_object(['A']){|n, a| a << n} #=> ["A", 1, 2, 3]
%w(foo bar).each_with_object({}) { |el, hh| hh[el.to_sym] = el } # => {'foo' => 'FOO', 'bar' => 'BAR'}
str = %w[a b c d].each.with_object('') do |s, obj|
  obj << s # += не мутирует строку
end #=> "abcd"
# обджект со значениями
[1,2,3].map.with_object({'a'=> 'b'}){|n, obj| obj[n] = n**2} #=> {"a"=>"b", 1=>1, 2=>4, 3=>9}
# primer
amount=127
hh={ H: 50, Q: 25, D: 10, N: 5, P: 1 }
p hh.each_with_object({}) { |(k, v), h| h[k], amount = amount/v, amount%v if amount >= v } #=> {:H=>2, :Q=>1, :P=>2}

# with_object. Метод хорошо сочетается с combination тк тот возврядает не массив
a = [0, 1, 2]
p a.repeated_combination(2).with_object([]) {|com, arr| arr << com } #=> [[0, 0], [0, 1], [0, 2], [1, 1], [1, 2], [2, 2]]
(0..n).to_a.repeated_combination(2).to_a


# Method ОТДЕЛЬНО .with_index (Enumerable)
[11,22,31,224,44].each.with_index { |el,i| puts "index: #{el} for #{i}" } # Индекс берется из объекта(0, 1, 2, 3, 4)
[11,22,31,224,44].each.with_index(2) { |el,i| puts "index: #{el} for #{i}" } # Индекс берется из аргумента по возрастающей(2, 3, 4, 5, 6)

[1,2,3,4,5,6,7,8,9,10].reject.with_index(1){|e, i| [1,5,10].include?(i)} #=> [2, 3, 4, 6, 7, 8, 9]

# Enumerable group_by
[1, 2, 5, 1, 5, 7, 4, 2].group_by { |i| i } #=> {1=>[1, 1], 2=>[2, 2], 5=>[5, 5], 7=>[7], 4=>[4]}
(1..6).group_by { |i| i%3 }   #=> {0=>[3, 6], 1=>[1, 4], 2=>[2, 5]}

# Enumerable
(1..6).partition { |v| v.even? }  #=> [[2, 4, 6], [1, 3, 5]]
"Such Wow!".chars.partition.with_index{|e,i| i.even?}  #=> [["S", "c", " ", "o", "!"], ["u", "h", "W", "w"]]


puts
puts '                                             Enumerator'

# class Enumenator
enumerator = %w(one two three).each
p enumerator.class #=> Enumerator
p enumerator       #=> #<Enumerator:0x00000195c74c19c8>
p enumerator.to_a  #=> ["one", "two", "three"]


# Создание перечислителя всех натуральных чисел
digits = Enumerator.new do |y|
  i = 0
  loop do
    y.yield i
    i += 1
  end
end
digits.next # => 0
digits.next # => 1
digits.take_while {|n| n < 13} # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]


# Создание перечислителя чисел Фебоначе
fib = Enumerator.new do |y|
  a, b = 0, 1
  loop do
    y.yield b # отправляем значение
    a, b = b, a+b
  end
end
fib.next # => 1
fib.next # => 1
fib.next # => 2
fib.take_while {|n| n < 100} # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]


# В методе
def quadratic_enum(a, b, c, options={})
  x = options[:start] || 0
  step = options[:step] || 1
  Enumerator.new do |y|
    loop do
      y.yield [x, a * x**2 + b * x + c]
      # y << [x, a*x**2+b*x+c]
      x += step
    end
  end
end
p quadratic_enum(1, 0, 0).take(3) # [[0, 0], [1, 1], [2, 4]]


# В классе наследнике
# https://www.codewars.com/kata/5d26721d48430e0016914faa  (6 kyu The PaperFold sequence)
class PaperFold < Enumerator
  def initialize
    super do | y |
      arr = [1]
      i = 0
      loop do
        y.yield arr[i]
        i += 1
        arr = arr.map.with_index{|e, i| i.even? ? [1, e] : [0, e]}.flatten + [0] if i >= arr.size
      end
    end
  end
end
p PaperFold.new.is_a?(Enumerator)# true
p PaperFold.new.take(20)# [1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1]
















#
