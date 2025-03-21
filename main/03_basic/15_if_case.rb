puts '                                  Условные операторы и ветвления'

# Бранчинг/ветвление - от англ. слова branch - ветвь. Подразумевается, что существует одна или более “ветвей” - участков кода, которые выполняются в зависимости от результата какого-либо сравнения.

# “Ветка”, “блок”, “бранч” - участок кода, который, возможно, будет исполнен при соблюдении некоторого условия.

# “Сравнение”, “тест” - непосредственно сама процедура сравнения, тестирование переменной на определенное значение.

# Операторы if должны всегда использоваться для определения верно ли условие, а операторы case используются когда необходимо сделать различные решения основанные на значении.



puts '                                               if'

# Операторы if должны всегда использоваться для определения верно ли условие, тоесть условие возвращает true или false

# Условие выражения if отделяется от кода зарезервированным словом then , новой строкой или точкой с запятой.
x, y = 9, 12
# Можно проверять на < > >= <= == != и другие условия
if x < y then # then писать не обязательно
  puts ("Икс меньше чем игрик")
  puts ("x < y")
end

# При переносе условия на след строку тоже работает
if
  x < y
  puts 1
end


# Примеры с булевыми переменными true и false(Значения false и nil ложны, а все остальное истинно)
isSmall = true

if isSmall == true
  puts ("OK")
end #=> "OK"

if isSmall # Ничего не указывая после переменной, по умолчанию проверяет на ее верность или существование
  puts ("OKe")
end #=> "OKe"

if !isSmall # знак отрицания ! можно ставить перед переменной вместо isSmall != true, тогда проверяет false
  puts ("no OK")
end



puts '                                   Возврат от условного оператора'

# Условные операторы возвращает значения, поэтому его можно присвоить в переменную
x = 1
name = if x == 1
	"one"
end
name #=> "one"

# Если условие в строке с if не выполняется то возвращается nil
p (if 2 > 3 then
  "Икс меньше чем игрик"
end) #=> nil

# Тк условный оператор возвращает значение, то можно применять к нему соответсвующие этому значению методы
if true
  'str'
end.chars #=> ["s", "t", "r"]

# Результат выполнения метода `stay_home` или `go_party` будет записан в переменную `result`.
x = is_it_raining?()
result = if x
  stay_home()
else
  go_party()
end



puts '                                         && (and) и || (or)'

# &&  (and)  - оператор логического и
# ||  (or)   - оператор логического или
# !   (not)  - оператор конвертирует истинное в ложное и наоборот

true && false #=> false
true || false #=> true

nil || 6      #=> 6
123 || 567    #=> 123    # выбирает первое значение если оба true

# Во всех языкаx у 'or' и  '||' разные приоритеты, Ruby - не исключение. Для интерпрератора это выглядит так:
p false or true   #=> false         # (p false) or true
p (false or true) #=> true
p false || true   #=> true          # p (false || true)

# условия можно переносить на новую строку при необходимости
x = 10
y = 10
p x == 10 && y ==
x && x + y ==
20 #=> true


# При нескольких условиях сначала проверяет первое, потом 2е итд слева направо
if isSmall and x == 9 # Можно объединять операции при помощи and значит и(выполняются оба)
  puts ("OK-2")
end

if isSmall or x != 9 # Обьединение при помощи or значит или(выполняется хотя бы одно)
  puts ("OK ili")
end



puts '                                              elsif и else'

# elsif - (иначе если) оператор альтернативного условия, он запускается если предыдущее условие не выполнено

# else - (иначе) оператор срабатыает если все условия после if и после elsif не выпоняются

# elsif без условия это тоже самое что и else

x, y = 20, 12
if x == y
  puts "x = y"
elsif x > y
  puts "x > y"
  # Вложенный условный оператор. Если проверка "материнского" оператора прошла, то выпоняется проверка его внутреннего оператора
  if y == 12
    puts "y = 12"
  end
elsif x == 5          # Операторов elsif может быть сколько угодно
  puts "Икс равно 5"
elsif x == 20         # Если несколько условий верные, будет выполнено только первое условие
  puts "Икс равно 20"
else
  puts "x не= y"
end



puts '                                            if в одну строку'

# Можно задавать условие для возврата(или выполнения какого либо действия) после этого действия оператором if в одну строку
day = '1'
'abc' if true               #=> abc
'abc' if false              #=> nil
'not crazy' if 2 + 2 == 4   #=> not crazy
'Понедельник' if day == '1' #=> Понедельник

# Множественное присвоение при помощи оператора and и if
a, b, c = 10, 50, 0
a = 1 and b = 2 if c == 0 #=> 1 2
p [a, b] #=> [1, 2]



puts "                                               unless"

# unless - (Если условие не выполняется, то...) оператор имеет абсолютно такой же синтаксис как if, но выполняется если условии не верно

unless x > 3 then
  x.to_s          # вернет значение x, если оно НЕ больше трёх.
else # Выполняется если условие верно
  "очень много, не сосчитать"
end

# Unless в одну строку
age = 25
puts "You are a minor" unless age <= 18



puts '                                         Тернарный оператор'

# Тернарный оператор (ternary operator) является однострочной альтернативой ("one-liner") конструкции "if...else".

# условие ? если_условие_true : если_условие_false  -  если условие выполнено, сработает то, что стоит между вопросиком и двоеточием, если не выполнено — то, что после двоеточия

# Тернарный оператор выглядит хорошо только тогда, когда нужно выполнить только одну инструкцию. Для нескольких методов подряд лучше использовать конструкцию "if...else".

# С помощью тернарного оператора код можно сократить так:
a > b ? puts("Одна строка") : puts("Другая строка")

# Или даже так:
puts a > b ? "Одна строка" : "Другая строка"

# Можно было бы записать ещё вот так, но это считается плохим стилем:
if a > b then puts "Одна строка" else puts "Другая строка" end

# Несколько условий:
a < b && c != 5 ? "go party" : 'stay home'

# Тернареый оператор с 2мя и более инструкциями, условие в условии можно писать в скобках, но не обязательно
x > 0 ? (y > 0 ? 1 : 4) : (y > 0 ? 2 : 3)
arr == arr.sort ? 'ascending' : arr == arr.sort.reverse ? 'descending' : 'no'


# У тернарного оператора в ruby один из самых низких приоритетов, ниже — только у операций присваивания, управляющих конструкций, блоков и т.д. Об этом важно помнить и использовать скобки если это необходимо:
'first ' + true ? 'second' : '2'   #=> in `+': no implicit conversion of true into String (TypeError)
'first ' + (true ? 'second' : '2') #=> "first second"


# Результат выражения с тернарным оператором можно также записать в переменную.:
result = is_it_raining?() ? stay_home() : go_party()
# `result` будет содержать результат выполнения операции `stay_home` или `go_party`.



puts '                                             case-when'

# case-when - оператор множественного выбора, он обеспечивает выбор из нескольких альтернатив

# Сопоставление с when вызывает метод '==='

# Условный оператор case удобно использовать при большом колличестве вариантогв boolean условий. Сложные ветвления и case лучше избегать. Лучше использовать с простыми перечислениями


# 1. Клаасический синтаксис case-when не работает с методами(напр <, >=) в условиях, но работает с диапазонами и набрами значений.

# Альтернативы в операторе case проверяются последовательно, выбирается первая ветвь, для которой условие соответствует значению, списку значений или диапазону
day = 7
case day                    # проверяем переменную day
when 1                      # когда переменная равна заданному значению...
  nameOfDay = "Понедельник" # ...то работает этот код
when 2
  nameOfDay = "Вторник"
# Выражение оператора when отделяется от кода зарезервированным словом then, новой строкой или точкой с запятой:
when 3                            # 1. перевод строки
  nameOfDay = "Среда"
when 4 then nameOfDay = "Четверг" # 2. оператор then
when 5; nameOfDay = "Пятница"     # 3. точка с запятой
else                        # Оператор else для case-when работает так же как и для if
  nameOfDay = "Выходной"
end
puts nameOfDay #=> Выходной

# when может принмать несколько возможных значений, разделенных запятыми.
x = rand(1..3)
case x
when 1,2,3               # Запятая в case это аналог || (or) в if
  puts "1, 2, or 3"
when 10
  puts "10"
else
  puts "Some other number"
end

# when может принмать диапазоны, тк сопоставление с when вызывает метод '==='
num = rand(0..100)
case num
when (20..25)
  puts 1
when (25..)
  puts 2
end

# when может принмать регулярки, тк сопоставление с when вызывает метод '==='
case 'aaa'
when '['
  1
when /^[A-Za-z]+$/
  2
when /^\d+$/
  3
when '('
  4
end

# может находить объект от константы
class Success end
class Error end
res = Error.new
p case res
when Success
  's'
when Error
  'e'
end #=> "e"


# 2. case-when можно запустить без передачи в case аргумента, но с дополнением условия в поле when, тогда выполнится первое when которое вернет true. Так будет возможно выполнение логических операций и соответсвенно операций сравнения(напр <, >=).
num = 11
case
when num.odd?
  puts 'odd'
when num.even?
  puts 'even'
end

# Альтернативный вариант записи без аргумента.
x = 1
case
  puts "x equal one" when x == 1
  puts "x equal two" when x == 2
end



puts '                                             case-in'


# case in - может проверять принадлежность нескольких значений, можно использовать регулярки. Нужно соблюдать порядок расположения
def quadrant(x, y)
  case [x, y]
    in [0.., 0..] then 1
    in [..0, 0..] then 2
    in [..0, ..0] then 3
    in [0.., ..0] then 4
  end
end
p quadrant(5, 3)   #=> 1
p quadrant(-20, 3) #=> 2
p quadrant(-1, -1) #=> 3
p quadrant(5, -1)  #=> 4

# С матчингом ркгулярок
def met(str)
  case str
    in /\d/ then 1
    in /a+/ then 2
    in /b+/ then 3
  else
    'pp'
  end
end
p met('12a') #=> 1
p met('ca')  #=> 2
p met('cc')  #=> "pp"


# case/in - реализует pattern matching - это сопоставление некоторой структуры с заданным образцом и деструктурирование этой структуры на составляющие.
case x
in [1,2,3]
  # ...
# Если x это массив из трех элементов 1 2 3.

case x
in [1,x,y]
  # ...
# Если x это массив из трех элементов и первый из них 1, то присвой два оставшихся элемента в переменные x и y.

case x
in [:define, [1,2], *vars]
  # ...
# Если x это массив из как минимум 2 элементов, из которых первый это символ :define, второй - это массив из двух элементов 1 и 2, и собери все оставшиеся элементы массива в vars.














#
