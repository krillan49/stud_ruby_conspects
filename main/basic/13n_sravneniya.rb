puts                               'Операторы сравнения (== === eql? equal? =~)'

# https://stackoverflow.com/questions/7156955/whats-the-difference-between-equal-eql-and

# ==, ===, eql?, equal?  – 4 компаратора, т.е. 4 способа сравнить два объекта в Ruby.
# Поскольку в Ruby все компараторы (и большинство операторов) на самом деле являются вызовами методов, можно самостоятельно изменять семантику этих методов сравнения.


puts
puts '                                               == и !='

# Операторы равенства: == и !=. Оператор ==, также известный как равенство или двойное равенство, возвращает true, если оба объекта равны, и false, если это не так.
"koan" == "koan" #=> true
# Оператор !=, также известный как неравенство, является противоположностью ==. Он вернет true, если оба объекта не равны, и false, если они равны.
"koan" != "discursive thought" # => true
# Обратите внимание, что два массива с одинаковыми элементами в разном порядке не равны, прописные и строчные варианты одной и той же буквы не равны и так далее.
# При сравнении чисел разных типов (например, целых и с плавающей запятой), если их числовое значение одинаково, == вернет true.
2 == 2.0 #=> true


puts
puts '                               equal?(сравнение идентичности объектов)'

# equal?(сравнение идентичности объектов) :equal? проверяет, относятся ли два операнда к одному и тому же объекту. Это самая строгая форма равенства в Ruby. Этот метод (класса BasicObject) не предполагается перезаписывать.
a, b = "zen", "zen" # есть две строки с одинаковым значением. Однако это два разных объекта с разными идентификаторами
a.object_id  #=> 20139460
b.object_id  #=> 19972120
a.equal? b  # => false
# Но если b будет ссылкой на a, то id объектов одинаков для обеих переменных, поскольку они указывают на один и тот же объект.
a = "zen"
b = a
a.object_id  #=> 18637360
b.object_id  #=> 18637360
a.equal? b  #=> true
a.equal? a.dup    # => false


puts
puts '                                      eql?(Сравнение хэш-ключей)'

# eql?(Сравнение хэш-ключей) В классе Hash команда eql? метод, который используется для проверки ключей на равенство.
# Ruby предоставляет встроенный метод hash для генерации хеш-кодов. В приведенном ниже примере он принимает строку и возвращает хеш-код. Обратите внимание, что строки с одинаковым значением всегда имеют один и тот же хеш-код, даже если они являются разными объектами (разные id).
"meditation".hash  #=> 1396080688894079547
"meditation".hash  #=> 1396080688894079547
# Хэш-метод реализован в модуле Kernel, включенном в класс Object, который по умолчанию является корневым для всех объектов Ruby. Некоторые классы, такие как Symbol и Integer, используют реализацию по умолчанию, другие, такие как String и Hash, предоставляют свои собственные реализации.
Symbol.instance_method(:hash).owner  #=> Kernel
Integer.instance_method(:hash).owner #=> Kernel
String.instance_method(:hash).owner  #=> String
Hash.instance_method(:hash).owner  #=> Hash
# В Ruby, когда мы сохраняем что-то в хеше (коллекции), объект, предоставленный как ключ (например, строка или символ), преобразуется и сохраняется как хеш-код. Позже, извлекая элемент из хеша (коллекции), мы предоставляем объект в качестве ключа, который преобразуется в хэш-код и сравнивается с существующими ключами. Если есть совпадение, возвращается значение соответствующего элемента. Сравнение производится с помощью команды eql? метод под капотом.
"zen".eql? "zen" #=> true
# Это тоже самое что и:
"zen".hash == "zen".hash #=> true
# В большинстве случаев eql? Метод ведет себя аналогично методу ==. Однако есть несколько исключений. Например, eql? не выполняет неявное преобразование типов при сравнении целого числа с числом с плавающей запятой.
2 == 2.0    #=> true
2.eql? 2.0    #=> false


puts
puts '                                               ==='

# 1. === (сравнение регистров)
# Многие встроенные классы как String, Range и Regexp, предоставляют свои собственные реализации оператора ===, также известного как регистр-равенство или тройное равенство. Поскольку в каждом классе он реализован по-разному, он будет вести себя по-разному в зависимости от типа объекта, к которому он был вызван. Обычно он возвращает true, если объект справа «принадлежит» или «является членом» объекта слева.
# Например, его можно использовать для проверки того, является ли объект экземпляром класса (или одного из его подклассов).
String === "zen"  #=> true
Range === (1..2)   #=> true
Array === [1,2,3]   #=> true
Integer === 2   #=> true
# целые числа, такие как 2, являются экземплярами класса Fixnum, который является подклассом класса Integer. is_a? и экземпляр_из? методы возвращают true, если объект является экземпляром данного класса или каких-либо подклассов.
2.is_a? Integer   #> true
2.kind_of? Integer  #=> true # алиас
2.instance_of? Integer #=> false # более строгий и возвращает true только в том случае, если объект является экземпляром именно этого класса, а не подкласса.
# is_a? и kind_of? методы реализованы в модуле ядра, который добавлен в класс Object. Оба являются псевдонимами одного и того же метода. Давайте проверим:
Kernel.instance_method(:kind_of?) == Kernel.instance_method(:is_a?) # Вывод: => true


# 2. Реализация диапазона ===. Когда оператор === вызывается для объекта диапазона, он возвращает true, если значение справа попадает в диапазон слева.
(1..4) === 2.345 #=> true
(1..4) === 6  #=> false
("a".."d") === "c" #=> true
("a".."d") === "e" #=> false
# === вызывает метод === левого объекта. (1..4) === 3 эквивалентно (1..4).=== 3. позиции операндов не являются взаимозаменяемыми.


# 3. Реализация регулярного выражения ===. Возвращает true, если строка справа соответствует регулярному выражению слева.
/zen/ === "practice zazen today" #=> true
# то же самое, что
"practice zazen today"=~ /zen/


# 4. Неявное использование оператора === в операторах case/when Это его наиболее распространенное использование.
minutes = 15
case minutes
when 10..20
  puts "match"
else
  puts "no match"
end #=> match
# если бы Ruby неявно использовал оператор двойного равенства (==), диапазон 10..20 не считался бы равным целому числу. Они совпадают, поскольку оператор тройного равенства (===) неявно используется во всех операторах case/when.
# Код в приведенном выше примере эквивалентен:
if (10..20) === minutes
  puts "match"
else
  puts "no match"
end


puts
puts '                                             =~ и !~'

# Операторы сопоставления с образцом: =~ (тильда равенства) и !~ (тильда-тильда) используются для сопоставления строк и символов с шаблонами регулярных выражений.

# Реализация метода =~ в классах String и Symbol ожидает в качестве аргумента регулярное выражение (экземпляр класса Regexp).
"practice zazen" =~ /zen/   #=> 11   # когда строка или символ соответствует шаблону регулярного выражения, возвращается целое число, которое является позицией (индексом) совпадения
"practice zazen" =~ /discursive thought/ #=> nil # Если совпадений нет, возвращается nil
:zazen =~ /zen/    #=> 2
:zazen =~ /discursive thought/  #=> nil
# Реализация класса Regexp ожидает в качестве аргумента строку или символ.
/zen/ =~ "practice zazen"  #=> 11
/zen/ =~ "discursive thought" #=> nil

# в Ruby любое целочисленное значение является «истинным», а nil — «ложным», поэтому оператор =~ можно использовать в операторах if и тернарных операторах.
"yes" if "zazen" =~ /zen/ #=> yes
"zazen" =~ /zen/ ? "yes" : "no" #=> yes

# Операторы сопоставления с образцом также полезны для написания более коротких операторов if
true if meditation_type == "zazen" || meditation_type == "shikantaza" || meditation_type == "kinhin"
# Can be rewritten as:
true if meditation_type =~ /^(zazen|shikantaza|kinhin)$/

# Оператор !~ является противоположностью оператора =~: он возвращает true, если совпадений нет, и false, если совпадение есть.














#