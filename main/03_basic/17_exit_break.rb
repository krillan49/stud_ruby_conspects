puts '                            Операторы: sleep, exit, break, next, redo, retry(?)'

# ОШИБКА retry



puts '                                            Метод sleep'

# sleep - метод позволяет ставить задержку с указанием времени в секундах.
def sl()
  p 'hi'
  sleep 3   # ждет 3 секунды
  p 'hi after 3 seconds'
  sleep 0.5 # ждет пол секунды
end



puts '                                           Оператор exit'

# exit - оператор завершает работу всей прграммы, начиная с того места в коде в котором он поставлен.
# Можно помещать в условные операторы, чтоб завершать программу только при выполнении заданных условий.
print "Сколько гостей к вам придет?: "
n = gets.to_i
if n < 0
	puts "Ошибка - введено отрицательное колличество гостей"
  exit # С этой строки программа завершит работу если условие блока выполняется.
end
puts "Придет #{n} гостей" # Этот код тоже исполняться не будет



puts '                                           Оператор break'

# break (прервать) - оператор завершает работу только того блока цикла или итератора в котором он записан, начиная со строки написания. Возвращает nil

# Работает аналогично с любыми циклами и итераторами(times, upto, downto, while, for, loop, each, select ...)
1.upto(300) do |x|
	n = rand(0..5)
	if n == 5
		break # цикл прервется и код ниже до границы цикла не будет исполнен, если эта строка исполнится
	end
  puts x
end # Завершает работу именно блока цикла
puts 'aaa' # Дальше программа будет исполняться



puts '                                           Оператор next'

# next - оператор переходит к следующей итерации цикла или итератора, не выполняя код ниже на текущей итерации. Прекращает выполнение блока, если вызывается внутри блока (с yield или call, возвращающим nil).
for i in 0..5
  if i < 2
    next # когда цикл проходят числа меньше 2х нижестоящий код цикла для них не работает
  end
  print "is-#{i}, "
end
#=> is-2, is-3, is-4, is-5,



puts '                                            Оператор redo'

# redo - оператор перезапускает(повторяет) эту итерацию самого внутреннего цикла или итератора без проверки состояния цикла. Перезапускает yield или call, если вызывается внутри блока
for i in 0..5
	if i < 2 then
		puts "Value of local variable is #{i}"
		redo
	end
end
# Это даст следующий результат и войдет в бесконечный цикл:
#=> Value of local variable is 0
#=> Value of local variable is 0
#=> ...

# Пример:
for i in 0..5
	if i < 2
		print "is #{i}, "
    n = i if !n
    n += 1
		redo if n < 5 # те мы задали повторение цикла для 1го элемента 6 раз
	end
end
#=> is 0, is 0, is 0, is 0, is 0, is 1,



puts '                                         Оператор retry(повторная попытка)'

# Если повторная попытка появляется в предложении спасения выражения начала, перезапустите с начала тела начала
begin
  do_something # exception raised
rescue
  # handles error
  retry  # restart from beginning
end


puts
#(ОШИБКА Invalid retry (SyntaxError))
# Если в итераторе появляется повтор, блок или тело выражения for перезапускает вызов итератора. Аргументы итератора оцениваются повторно.
for i in 0..5
	retry if i > 2
	puts "Value of local variable is #{i}"
end
# Это даст следующий результат и войдет в бесконечный цикл —
#=> Value of local variable is 1
#=> Value of local variable is 2
#=> Value of local variable is 1
#=> Value of local variable is 2
#=> ...












# 