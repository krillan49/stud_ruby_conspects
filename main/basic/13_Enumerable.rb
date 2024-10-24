puts '                                             Enumerable'

# Enumerable - module, стандартный модуль, который можно включить в класс при помощи include. Если в этом классе реализован метод each, то все остальные 53 метода стандартных коллекций (map, reduce, select, reject и т.п.) автоматически строятся модулем Enumerable на основе одного-единственного метода each



puts '                                            max_by, min_by'

# max_by / min_by - метод (Enumerable). Возвращает элементы, для которых блок возвращает максимальные/минимальные значения.

# 1. С заданным блоком и без аргумента возвращает элемент, для которого блок возвращает максимальное значение:
(1..4).max_by {|element| -element }                    #=> 1
%w[a b c d].max_by {|element| -element.ord }           #=> "a"
{foo: 0, bar: 1, baz: 2}.max_by {|key, value| -value } #=> [:foo, 0]
[].max_by {|element| -element }                        #=> nil

# 2. С заданным блоком и заданным целочисленным положительным аргументом n возвращает массив, содержащий n элементов, для которых блок возвращает максимальные значения:
(1..4).max_by(2) {|element| -element }                     #=> [1, 2]
%w[a b c d].max_by(2) {|element| -element.ord }            #=> ["a", "b"]
{foo: 0, bar: 1, baz: 2}.max_by(2) {|key, value| -value }  #=> [[:foo, 0], [:bar, 1]]
[].max_by(2) {|element| -element }                         #=> []



puts '                                     each_with_object, with_object'

# 1. each_with_object - метод (Enumerable) - вызывает блок один раз для каждого элемента, передавая как элемент, так и данный объект:

# С пустым объектом
(1..4).each_with_object([]) {|i, arr| arr.push(i**2) }           #=> [1, 4, 9, 16]
%w(foo bar).each_with_object({}) { |el, hh| hh[el.to_sym] = el } #=> {'foo' => 'FOO', 'bar' => 'BAR'}
%w[a b c d].each.with_object('') { |c, str| str << c }           #=> "abcd"

# Объект со значениями
[1, 2, 3].each.with_object(['A']){|n, a| a << n}                 #=> ["A", 1, 2, 3]
[1, 2, 3].map.with_object({'a'=> 'b'}){|n, obj| obj[n] = n**2}   #=> {"a"=>"b", 1=>1, 2=>4, 3=>9}


# 2. with_object - метод хорошо сочетается с combination тк тот возврядает не массив а перечисляемое
[0, 1, 2].repeated_combination(2).with_object([]) {|com, arr| arr << com } #=> [[0, 0], [0, 1], [0, 2], [1, 1], [1, 2], [2, 2]]



puts '                                             with_index'

# with_index - метод (Enumerable). Индекс берется от элементов объекта по порядку и передается во 2ю переменную блока
[11,22,31,224,44].each.with_index { |el,i| puts "index: #{el} for #{i}" }

# Можно задать стартовый индекс при помощи параметра
[11,22,31,224,44].each.with_index(2) { |el,i| puts "index: #{el} for #{i}" } #=> (2, 3, 4, 5, 6)
[1,2,3,4,5,6,7,8,9,10].reject.with_index(1){|e, i| [1,5,10].include?(i)}     #=> [2, 3, 4, 6, 7, 8, 9]



puts '                                            Разные методы'

# group_by - метод Enumerable
[1, 2, 5, 1, 5, 7, 4, 2].group_by { |i| i } #=> {1=>[1, 1], 2=>[2, 2], 5=>[5, 5], 7=>[7], 4=>[4]}
(1..6).group_by { |i| i%3 }                 #=> {0=>[3, 6], 1=>[1, 4], 2=>[2, 5]}

# partition - метод Enumerable, разбивает перечисляемое на подмассивы 2д массива, по условию заданному в блоке
(1..6).partition { |v| v.even? }                       #=> [[2, 4, 6], [1, 3, 5]]
"Such Wow!".chars.partition.with_index{|e,i| i.even?}  #=> [["S", "c", " ", "o", "!"], ["u", "h", "W", "w"]]
















#
