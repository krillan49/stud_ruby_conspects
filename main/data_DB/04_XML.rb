puts '                                                XML'

# На Руби есть несколько библиотек XML-парсеров

# REXML - встроенная (и самая простая) библиотека XML-парсер, переводит содержние XML-фаила в удобный формат (? ассоциативного массива ?)
# https://github.com/ruby/rexml



puts '                                       REXML. Чтение XML-фаилов'

require "rexml/document" # подключаем библиотеку REXML
require "date"

current_path = File.dirname(__FILE__)
file_name = current_path + "/xml/my_expenses.xml"

p file_name

# прерываем выполнение программы досрочно, если файл не существует.
abort "Извиняемся, хозяин, файлик my_expenses.xml не найден." unless File.exist?(file_name)

file = File.new(file_name) # открыли XML-файл

doc = REXML::Document.new(file)
# Document - класс библиотеки REXML, создает новый объект REXML::Document, построенный из открытого XML файла

amount_by_day = Hash.new # пустой хэш, куда сложим все траты по дням

# выбираем из элементов документа все тэги <expense> внутри <expenses> и в цикле проходимся по ним
doc.elements.each("expenses/expense") do |item|
  # elements - метод REXML::Document возвращает массив всех элементов документа REXML
  # each("expenses/expense") - метод итератор REXML::Document, принмимает адрес вложенности элемента внутри XML-дерева для итерации по последнему в нем уровню элементов, тут элементов "expense". Это называется XPath - формат адресации расположения элементов внутри XML-дерева

  loss_sum = item.attributes["amount"].to_i # сколько потратили
  # attributes - метод возврвщает хэш с атрибутами и их значениями в виде строк для даднного элемента(тега), тут из переменной item

  loss_date = Date.parse(item.attributes["date"]) # создаем из строки объект Date

  # иницилизируем нулем значение хэша для результатов, если этой даты еще не было
  amount_by_day[loss_date] ||= 0
  amount_by_day[loss_date] += loss_sum  # добавили трату за этот день
end

# Можно вытаскивать точечно без итерации например так (на другом примере)
some.root.elements['REPORT/TOWN'].attributes["date"]
# some - объект REXML::Document, построенный из открытого XML файла
# root - метод берет от корня XML-документа, ?? тоесть точечно юзаем как дерево, тоесть elements теперь вытягивает только элементы от корня и уже ключем передаем цепочку дальше к конкретному элементу, а итерация тупо все теги ??
el = some.root.elements['REPORT/TOWN'].elements.to_a[0] # а тут берем не атрибуты и все теги этого уровня и 1й их них ?? вернется объект к которому тоже можно применить elements и attributes
el.elements['SOME'].attributes["wtf"]

file.close

# сделаем хэш, в который соберем сумму расходов за каждый месяц
sum_by_month = Hash.new
# в цикле по всем датам хэша amount_by_day накопим в хэше sum_by_month значения потраченных сумм каждого дня
amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime("%B %Y")] ||= 0 # key.strftime("%B %Y") вернет одинаковую строку для всех дней одного месяца поэтому можем использовать ее как уникальный для каждого месяца ключ
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key] # приплюсовываем к тому что было сумму следующего дня
end

# вывод статистики на экран, в цикле пройдемся по всем месяцам и начнем с первого
current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

# выводим заголовок для первого месяца
puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]--------"

# цикл по всем дням
amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month # если текущий день принадлежит уже другому месяцу...
    # то значит мы перешли на новый месяц и теперь он станет текущим
    current_month = key.strftime("%B %Y")
    # выводим заголовок для нового текущего месяца
    puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]--------"
  end
  # выводим расходы за конкретный день
  puts "\t#{key.day}: #{amount_by_day[key]} р."
end



puts '                                       REXML. Запись в XML-фаилы'

# Мы передаем XML-документ и объект файла парсеру и он сам пишет в него данные как надо. Мы хотим программу, которая позволит нам ввести в консоли трату (описание, категорию, дату и количество потраченных денег), а потом допишет её в наш файл expenses.xml

require "rexml/document" # подключаем парсер
require "date"           # будем использовать операции с данными

puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp
puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i
puts "Укажите дату траты в формате ДД.ММ.ГГГГ, например 12.05.2003 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

# Для того, чтобы записать дату в удобном формате, воспользуемся методом parse класса Time
expense_date = nil
if date_input == '' # Если пользователь ничего не ввёл, значит он потратил деньги сегодня
  expense_date = Date.today
else
  begin
    expense_date = Date.parse(date_input)
  rescue ArgumentError # если дата введена неправильно, перехватываем исключение и выбираем "сегодня"
    expense_date = Date.today
  end
end

# Наконец, спросим категорию траты
puts "В какую категорию занести трату"
expense_category = STDIN.gets.chomp


current_path = File.dirname(__FILE__)
file_name = current_path + "/xml/my_expenses.xml"

# Прежде чем что-то дозаписывать, сначала получим текущее содержимое файла.
file = File.new(file_name, "r:UTF-8") # считам в правильной кодировке, чтобы не было такого что считали в одной, а запишем в другой
doc = nil
begin
  doc = REXML::Document.new(file) # создаем новый объект REXML::Document, построенный из открытого XML файла
rescue REXML::ParseException => e # если парсер ошибся при чтении файла, придется закрыть прогу :(
  puts "XML файл похоже битый :("
  abort e.message
end
file.close

# Добавим трату в нашу XML-структуру в переменной doc

# Для этого найдём элемент expenses (корневой)
expenses = doc.elements.find('expenses').first
# find('expenses') - вернет коллекцию элементов(тегов) expenses в массиве всех элементов возвращенном методом elements. Так как expenses это корневой тег, то можем вернуть его из маситва любым удобным способом, например методом first

# add_element - метод экземпляра тега, для того чтобы добавить в него другие теги и задать их атрибуты. Возвращает этот добавленный элемент. (тут добавим новый тег в тег из переменной expenses)
# 'expense' - аргумент названия тега, который добавим
# далее передаем блок со всеми атрибутами и их хначениями в виде хэша
expense = expenses.add_element 'expense', {
  'amount' => expense_amount,
  'category' => expense_category,
  'date' => expense_date.strftime('%Y.%m.%d') # or Date#to_s
}
# text - метод экземпляра тега, чтобы добавить простой текст в тело тега (добавим текст в добавленный в дерево тег)
expense.text = expense_text

# Осталось только записать обновленную XML-структуру в файл методом write
file = File.new(file_name, "w:UTF-8") # запишем в правильной кодировке, чтобы не было такого что считали в одной, а запишем в другой
doc.write(file, 2) # 2й аргумент это число отступов в виде пробелов
file.close



puts '                                     Ошибки в синтаксисе XML-файлов'

# Всеггда есть возможность ошибки, например, незакрытый тег или забытая треугольная скобка. Парсер сообщит о таких ошибках.

# Например, удалим закрывающий тег корневого контейнера </expenses> в файле my_expenses.xml.
# $ ruby expenses_reader.rb          => No close tag for /expenses (REXML::ParseException)

# Обработаем ошибку:
begin
  doc = REXML::Document.new(file) # создаем новый объект REXML::Document, построенный из открытого XML файла
rescue REXML::ParseException => e
  puts "Похоже, файл #{file_name} испорчен:"
  abort e.message
end












#
