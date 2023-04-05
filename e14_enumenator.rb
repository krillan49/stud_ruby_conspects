puts '                                             Enumerator'

# class Enumenator
enumerator = %w(one two three).each
puts enumerator.class #=> Enumerator
puts enumerator #=> #<Enumerator:0x00000195c74c19c8>
p enumerator.to_a #=> ["one", "two", "three"]


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
fib=Enumerator.new do |y|
  a,b=0,1
  loop do
    y.yield b # отправляем значение
    a,b=b,a+b
  end
end
fib.next # => 1
fib.next # => 1
fib.next # => 2
fib.take_while {|n| n < 100} # => [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]


# В методе
def quadratic_enum(a,b,c,options={})
  start = options[:start] || 0
  step = options[:step] || 1
  Enumerator.new do |y|
    x=start
    loop do
      y.yield [x, a*x**2+b*x+c]
      # y << [x, a*x**2+b*x+c]
      x+=step
    end
  end
end
p quadratic_enum(1, 0, 0).take(3) # [[0, 0], [1, 1], [2, 4]]


# В классе наследнике
# https://www.codewars.com/kata/5d26721d48430e0016914faa  (6 kyu The PaperFold sequence)
class PaperFold < Enumerator
  def initialize
    super do | y |
      arr=[1]
      i=0
      loop do
        y.yield arr[i]
        i+=1
        arr=arr.map.with_index{|e,i| i.even? ? [1, e] : [0, e]}.flatten+[0] if i>=arr.size
      end
    end
  end
end
p PaperFold.new.is_a?(Enumerator)# true
p PaperFold.new.take(20)# [1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1]
