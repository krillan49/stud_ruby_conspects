#============================================
# https://ruby-doc.org/   Документация руби
#============================================

# https://www.tutorialspoint.com/ruby/index.htm
# http://phrogz.net/programmingruby/

# https://namingconvention.org/   -   ruby naming convention (как правильно называть переменные методы классы итд)

# В руби принято делать отступы 2мя пробелами а не табуляцией

# Код в руби можно писать через точку с запятой в одной строке
a = 5; puts a #=> 5


Kernel.methods #=> все методы, по которым можно посмотреть и другие методы

# & - это safe navigation. Убеждается, что объект не nil, после чего идёт дальше, либо возвращает nil
[1, 2, 3].find{|e| e.class == Array }&.sum #=> nil
[1, 2, 3].find{|e| e.class == Array }.sum #=> undefined method `sum' for nil:NilClass (NoMethodError)


# перевод 2ичной строки в 8битные числа перевод в 10чные и применение к ним .chr
['0100100001100101011011000110110001101111'].pack('B*') #=> "Hello"

'122.99.9.99.999'.next #=> "123.00.0.00.000"

# сравнение версий
Gem::Version.new('3.0.10') <=> Gem::Version.new('3.01.1') #=> -1


# tap позволяет манипулировать object и возвращать его после блока(создает новый объект те не мутирует):
[1,2].tap{ |arr| arr << 't'} #=> [1, 2, "t"]


p 'a'.itself #=> "a"
# пример применения
p 3.times.to_a.zip([:to_s,:to_f,:itself]).map{|s, o| s.send(o)} #=> ["0", 1.0, 2














#
