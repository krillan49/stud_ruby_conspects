puts '                                         ООП: Типы переменных в классе'

# 1. local variable/локальная переменная/local_var - переменная доступная только внутри метода, можно определить(объявить) только в том же методе. Если локальная переменная не объявлена, то будет ошибка исполнения программы. Локальные переменные начинаются со строчной буквы или с символа "_".

# 2. instance variable/переменная экземпляра класса/@instance_var - доступня во всех методах класса, можно определить в любом методе класса. Эти переменные определяют состояние объекта. Желательно объявлять instance variables в конструкторе. Если переменная экземпляра класса не объявлена, то ее значение по-умолчанию будет равно nil и ошибки как с необъявленной локальной переменной не будет. Имеют разные значения для разных объектов.

# 3. class variable/переменная класса(переменная шаблона/статическая переменная)/@@class_var - переменная сохраняет свое значение во всех экземплярах класса(для всех объектов класса эта переменная будет одинакова). Например если мы меняем ее значение для одного объекта, то ее значение изменится на такое же для других объектов класса. Удобно использовать например для счетчиков при инициализации в конструкторе. Переменная класса принадлежит классу и является характеристикой класса. Невозможна инициализация вне тела класса. Неинициализированная переменная класса приводит к ошибке.

# 4. global variable/глобальная переменная/$global_var - доступна во всей программе как вне так и внутри класса, можно определить ее вне класса и она будет доступна и внутри класса и в любом месте кода вне класса. Неинициализированные глобальные переменные имеют значение nil и выдают предупреждения с опцией -w.

# 5. CONSTANT константа - значение этой переменной никогда не меняется(Как только константа определена, вы не можете изменить ее значение), определяется без метода. Нужна для задания неких констант, например PI = 3.14. Имя константы начинается с заглавной буквы. К константам, определенным внутри класса или модуля, можно получить доступ из этого класса или модуля, а к константам, определенным вне класса или модуля, можно получить глобальный доступ. Константы не могут быть определены внутри методов. Ссылка на неинициализированную константу приводит к ошибке

# Специальные переменные. Например, переменная `ARGV` содержит аргументы, переданные в программу. А переменная `ENV` содержит параметры окружения (environment) - т.е. параметры, которые заданы в вашей оболочке (shell).

$global_var = 'Доступна везде. Определяется где угодно'
CONSG = 'Константа вне класса'
class App
  CONSTANT = 'Значение никогда не меняется. Попытка изменения выдаст ошибку'
  @@class_var = 'Одно значение для всех экземпляров класса'
  def initialize
    @instance_var = 'Доступна в методах класса. Определяется в методах класса'
  end
  def print_variables
    local_var = 'Доступна и определяется только в конкретном методе'

    puts $global_var
    puts CONSTANT
    puts @@class_var
    puts @instance_var
    puts local_var

    ::CONSG # Вызов константы извне тела класса в тело класса
  end
  def chenge_class_var
    @@class_var += ' +1'
  end
  def print_class_var
    puts @@class_var
  end
end

App.new.print_variables #=> значения всех переменных выводимых(puts) методом print_variables
puts $global_var #=> "Доступна везде. Определяется где угодно"

# Примеры для @@class_var
a = App.new
a.print_class_var #=> "Одно значение для всех экземпляров класса"
puts a.chenge_class_var #=> "Одно значение для всех экземпляров класса +1"
b = App.new
b.print_class_var #=> "Одно значение для всех экземпляров класса +1"
puts b.chenge_class_var #=> "Одно значение для всех экземпляров класса +1 +1"
c = App.new
c.print_class_var #=> "Одно значение для всех экземпляров класса +1 +1"

# Получить доступ к константе класса вне класса(classname::constant)
puts App::CONSTANT #=> "Значение никогда не меняется. Попытка изменения выдаст ошибку"


puts
puts '                                        Меморизация'

# При помощи константы или другой переменной с доступом в метод
HH=[0,1]
def fibonacci(n)
  return HH[n] if HH.size>=n
  n.times do
    HH << HH.last(2).sum
  end
  HH[n]
end
