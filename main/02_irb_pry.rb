puts '                                             irb'

# irb (interactive ruby) - REPL-программа(read (R)(прочитать), evaluate (E)(выполнить), print (P), (loop - L))
# > irb      # - интерпритатор Руби сразу в консоли.
# Завершить работу в irb можно в любой момент нажав ctrl+c

# С:\Projects\MyApp1>irb      (нажимаем enter)
# irb(main):001:0> 2+2*2
# => 6                        (интерпритатор возвращает(=>) нам результат действия)
# irb(main):002:0> puts 2+2*2
# 6                           (puts(ничего не считает только выводит) выводит результат действия)
# => nil                      (а интерпритатор возвращает уже nil)
# irb(main):003:0> exit       (exit команда выхода из irb  интерпритатора Руби)


puts
puts '                                             pry'

# https://github.com/pry/pry     http://pry.github.io/

# pry - “An IRB alternative and runtime developer console” те альтернатива уже известному нам REPL - IRB. В pry реализовано больше возможностей, чем в irb.

# Проверка установлен ли pry в вашей системе:
# > which pry

# Установка:
# $ gem install pry
# $ gem install pry pry-doc

# Запуск:
# $ pry

# Команды внутри pry:
# > help          - выводит справку по всем возможным командам
# > whereami -h   - получить подробную справку по любой команде: название команды и через пробел в конце добавить -h


# (!!! Ругается на виндоус(но работает), просит почитать документацию для корректной работы на виндоус):
#For a better Pry experience on Windows, please use ansicon:
  #https://github.com/adoxa/ansicon
#If you use an alternative to ansicon and don't want to see this warning again,
#you can add "Pry.config.windows_console_warning = false" to your pryrc.


puts
# Важный момент в pry — конфигурация. Gem это, грубо говоря, плагин для языка(или экосистемы) руби. Но и для «плагина» pry существует свое множество плагинов:

# awesome print - Gem который содержит в себе библиотеку кода, плагин для pry, плагин для irb.
# https://github.com/awesome-print/awesome_print
# > gem install awesome_print

# (!!! ОШИБКА при подключении - системе не удается найти указанный путь)
# Подключение(Гем awesome_print подключается к pry только один раз на вашем компьютере):
# > cat > ~/.pryrc          # запускаем в терминале команду cat, которая считывает из стандартного ввода следующие две строки (мы должны их ввести с клавиатуры).
# require 'awesome_print'
# AwesomePrint.pry!
# ^D                        # В конце мы нажимаем Ctrl+D — комбинацию, которая говорит о том, что ввод закончен (в листинге выше это обозначается как ^D)










#
