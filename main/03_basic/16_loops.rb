puts '                                               Циклы'

# Циклы в Ruby используются для выполнения одного и того же блока кода определенное количество раз

# Цикл может содержать в своем теле другой цикл - иногда его называют “вложенный цикл”, “double loop / двойной цикл”, если имеют в виду цикл по `i` - то “inner loop”, “внутренний цикл”



puts '                                               while'

# while ("пока истинно") - цикл не задает сам переменные и содержит только условие, которое отделяется от тела цикла: зарезервированным словом do, новой строкой или точкой с запятой. Цикл перезапускается пока условие будет является истинной(true). Если условие не меняется(while 2+2=4) и постоянно является true то цикл будет выполняться бесконечное колличество раз. Сам цикл возвращает nil.

# Переменные для использования в цикле задаются отдельно
i, some = 0, true
# Условие может быть составным и содержать несколько подусловий:
while i <= 5 && some # отделяем условие от тела при помощи перевода строки
  i += 1
  some = [false, true].sample
end

while i <= 10 do i += 1 end # отделяем условие от тела при помощи do
while i <= 15; i += 1 end   # отделяем условие от тела при помощи точки с запятой


# Не создает новую область для локальных переменных. Переменная заданная в теле цикла, остаетс определена и после.
i = 1
while i <= 5
  i += 1
  n = 2
end
p n #=> 2
p i #=> 6


# begin-while - этот тот же цикл while, только с проверкой в конце. Тоесть код тела цикла вне зависимости от условий будет выполнен 1 раз, чтоб не писать его еще раз перед телом цикла. + удобно создавать проверяемую условием переменную в теле цикла
i, list = 0, [3, 2, 1]
begin
  n = list[i]
  i += 1
end while i < n

# Однострочный синтаксис begin-while
a = 5
puts "#{a -= 1}" while a > 2 #=> 4 3 2



puts '                                                until'

# until ("пока не истинно") - аналог while, но выполняет код пока условие имеет значение false.

i = 0
until i == list.size
  print "#{list[i]} "
  i += 1
end

# begin-until с проверкой в конце
i = 0
begin
  print "#{list[i]} "
  i += 1
end until i == list.size

# Однострочный синтаксис begin-until
a = 5
puts "#{a += 1}" until a == 8 #=> 6 7 8



puts '                                                 loop'

# loop - метод/цикл работает аналогично циклу while у которого условие true, тоесть всегда бесконечный. Прерывается только применением дополнительных операторов в его теле, например break. Создает новую область для локальных переменных. Переменная заданная в теле цикла, не будет определена после.
i = 10
loop do
  puts "hi"
  i -= 1
  n = 2
  break unless i <= 5 # прерывается только доп оператором
end
p i #=> 6
p n #=> 2 # undefined local variable or method `n' for main:Object (NameError)



puts '                                                for in'

# for in - цикл задает переменную в своем синтаксисе в которую передает каждое значение из проверяемого выражения после in. Выполняет код один раз для каждого элемента в выражении. Выражение цикла for отделяется от кода зарезервированным словом do, новой строкой или точкой с запятой(но не фиг скобками). Цикл for in  почти точно эквивалентен итератору each, только цикл for не создает новую область для локальных переменных.

x, y = 0, 5
for per in x..y # в переменную (тут per) присваивается каждое значение из диапазона
  print per #=> 012345 # Будет выводить каждое число диапазона пока они не кончатся
end

# Не создает новую область для локальных переменных. Переменная заданная в теле цикла, остаетс определена и после.
b = 10
for per in 0..5
  a = true
  b = per
  print per
end
p a #=> true
p b #=> 5

# Пример для перебора массива (примерно как each)
names = ["Bob", "Kevin", "Alex", "George"]
for name in names # Будет выбирать в диапазоне массива nameS
  name += "!"     # В цикле удобно добавлять каждому элементу что-то, чтоб не прописывать для каждго отдельно
  puts name       # выведет каждый элемент массива
end
p names # выведет без добавленных знаков ! тк сам массив не был изменен циклом а только использован

# Пример цикла for изменяющего массив (примерно как map)
for i in 0..names.length()-1
  names[i] += "!" # Теперь к значению под индексом заданным переменной i добавится '!'
end
p names #=> ["Bob!", "Kevin!", "Alex!", "George!"]

# Для значений по убыванию можно реверсировать диапазон
for i in (1..7).reverse_each do
  p i #=> 7 6 5 4 3 2 1
end












#