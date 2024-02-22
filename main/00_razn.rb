#============================================
# https://ruby-doc.org/   Документация руби
#============================================

# https://www.tutorialspoint.com/ruby/index.htm
# http://phrogz.net/programmingruby/

# https://namingconvention.org/   -   ruby naming convention (как правильно называть переменные методы классы итд)

# (constant time, O(1)) константное время. Сколько бы элементов мы не добавили в наш хеш, поиск всегда будет занимать одно и то же время(сразу найдет нужное).
# (linear time, O(N)) линейное время. Для поиска элемента нам необходимо перебрать весь массив (с помощью конструкции each). Если элементов будет много, то поиск будет занимать больше времени. Другими словами, с возрастанием размера массива возрастает и количество элементов, которое требуется просмотреть чтобы найти слово.
# Константное O(1) и линейное O(N) время это понятия о т.н. Big-O (большое O), понятие из Computer Science.


# module Enumerable - Это такой стандартный модуль, который вы можете включить в класс при помощи include, если в этом классе реализуете метод each, то все остальные 53 метода стандартных коллекций (map, reduce, select, reject и т.п.) автоматически строятся модулем Enumerable на основе одного-единственного метода each

p Kernel.methods #=> все методы, по которым можно посмотреть и другие методы


require 'some' # require - требовать

# перевод 2ичной строки в 8битные числа перевод в 10чные и применение к ним .chr
['0100100001100101011011000110110001101111'].pack('B*') #=> "Hello"

'122.99.9.99.999'.next #=> "123.00.0.00.000"

# сравнение версий
Gem::Version.new('3.0.10') <=> Gem::Version.new('3.01.1') #=> -1


# ( Рэилс )Возвращает true, если этот объект включен в аргумент. Аргументом должен быть любой объект, который отвечает на #include?.
characters = ["Konata", "Kagami", "Tsukasa"]
"Konata".in?(characters) # => true


# Проверка корректности айпи ipv4(от 0.0.0.0 до 255.255.255.255)
require 'ipaddr'
IPAddr.new(ip).ipv4?


# Хэширование MD%5(https://ruby-doc.org/stdlib-3.0.0/libdoc/digest/rdoc/Digest/MD5.html)
require 'digest'
Digest::MD5.hexdigest('12345') #=> "827ccb0eea8a706c4c34a16891f84e7b"   # хэширование
# Взлом MD5 для 5значных пинкодов состоящих только из цифр перебором
hashmd5="827ccb0eea8a706c4c34a16891f84e7b"
('00000'..'99999').find{|pin| Digest::MD5.hexdigest(pin)==hashmd5} #=> "12345"
# Хэширование SHA2 https://ruby-doc.org/stdlib-2.4.0/libdoc/digest/rdoc/Digest/SHA2.html
require 'digest'
Digest::SHA2.hexdigest('code') #=> '5694d08a2e53ffcae0c3103e5ad6f6076abd960eb1f8a56577040bc1028f702b'
('a'..'zzzzz').find{|code| Digest::SHA1.hexdigest(code)==hash}



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

p [1,2,3,4,5,6,7,8,9,10].reject.with_index(1){|e, i| [1,5,10].include?(i)} #=> [2, 3, 4, 6, 7, 8, 9]

# Enumerable group_by
[1, 2, 5, 1, 5, 7, 4, 2].group_by { |i| i } #=> {1=>[1, 1], 2=>[2, 2], 5=>[5, 5], 7=>[7], 4=>[4]}
(1..6).group_by { |i| i%3 }   #=> {0=>[3, 6], 1=>[1, 4], 2=>[2, 5]}

# Enumerable
(1..6).partition { |v| v.even? }  #=> [[2, 4, 6], [1, 3, 5]]
"Such Wow!".chars.partition.with_index{|e,i| i.even?}  #=> [["S", "c", " ", "o", "!"], ["u", "h", "W", "w"]]


# tap позволяет манипулировать object и возвращать его после блока(создает новый объект те не мутирует):
p [1,2].tap{ |arr| arr << 't'} #=> [1, 2, "t"]



# & это safe navigation, так называемый. убеждается, что объект не nil, после чего идёт дальше. бывает, что надо написать что то такое
Model.find(id).some_associations.last&.some_field


# методы и блоки в руби не являются объектами и в случае методов ими управляет специальный класс под названием Method, в котором пару раз меняли имплементацию и сейчас она такая, какая есть в руби. Именно благодаря этому мы можем работать с методами

















# 
