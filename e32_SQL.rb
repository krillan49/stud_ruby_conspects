'                                                 SQL(SQLite3)'

# https://sqlitebrowser.org/dl/  инструмент-браузер для SQLite(мб еще для чегото)
#
# SQLite — это библиотека на языке C, которая реализует небольшой, автономный, полнофункциональный механизм базы данных SQL.
#
# Скачивание и установка:
# https://sqlite.org/index.html  ->  Download  ->  Precompiled Binaries for Windows  ->  https://www.youtube.com/watch?v=ZSOyqH3loss  https://lumpics.ru/how-install-sqlite-on-windows-10/

# sqlite3 --version   -  проверить версию
# sqlite3             -  войти в программу(в оболочку/shell программы) (выход Ctrl+C или прописать .exit)

# sqlite3 название_базы_данных.расширение                     - войти(в соответсвующей директории) в конкретную базу данных(в ее рабочую текстовую консольную оболочку) например testDB.sqlite
# sqlite3 ./DB/leprosorium.db                                 - войти с указанием доп пути
# CREATE TABLE "Some" ("Id" INTEGER PRIMARY KEY AUTOINCREMENT, "Name" VARCHAR, "Price" INTEGER);  - запрс создания новой таблицы в данной базе данных (среда позволяет писать запросы в несколько строк соотв в конце запроса(именно запроса не команды) точка с запятой, иначе на другую строку переходит ввод запроса, можно поставить и на новой строке)
# .tables                                                     - вывести список таблиц которые существуют вданной базе данных
# SELECT * FROM Cars;                                         - пример запроса SELECT, получаем вывод таблицы или ее элементов
# .mode column                                                - изменяет визуальный стиль вывода таблицы на такой чтоб колонки были ровными
# .headers on                                                 - Включить заголовки(похоже включена автоматически и так в .mode column)
# INSERT INTO Cars (Name, Price) VALUES ('Foo', 6743);        - пример запроса INSERT, добавим новую строку в таблицу
# .exit                                                       - выйти из базы данных

# тобы в командной строке sqlite3 каждый раз не писать, показывать в столбец и с заголовками, создайте в домашней директории файл .sqliterc с содержимым:
# .headers on
# .mode column


puts
puts '                                            sqlite3 gem'

# https://www.rubydoc.info/github/luislavena/sqlite3-ruby       --  документация

# gem install sqlite3   -  библиотека для Руби

#(не забываем добавлять базы данных в гитигнор)

require 'sqlite3' # подключение как и везде

db = SQLite3::Database.new('test.sqlite') # подключаем/создаем базу данных test.sqlite(тут) как объект класса Database, прописывая к ней путь и присваиваем ее в переменную. Если этот фаил уже создан то откроет его, а если не создан то создаст с этим именем в текущем каталоге приложения(можно поменять путь на любой).

# execute - метод, который принимает аргументом строку запроса и исполняет ее.(точка с запятой в конце команды необязательны тк execute подразумевает выполнение только одной команды)

db.execute 'CREATE TABLE IF NOT EXISTS "Cars" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "Name" TEXT, "Price" INTEGER)' # создаем в этой базе таблицу если она не создана.(кавычки в названии столбцов не обязательно)

db.execute "INSERT INTO Cars (Name, Price) VALUES ('Kroker', 9000)"  # Запрос в 2йных кавычках, чтобы внутри можно было использовать одинарные для запросов и интерполяцию ввода запроса или его части переменными, например "INSERT INTO Cars (Name, Price) VALUES (#{@name}, 9000)", что удобно для пользователя

# вывод из БД:
db.execute "SELECT * FROM Cars" do |car| # результат выполнения метода execute отправляется в лямбду и присваивает результаты(таблицу построчно в виде массива по колонкам) в переменную как итератор.
	p car    #=> [1, 'Kroker', 9000]
end

db.execute("SELECT * FROM Cars").class #=> Array . Весь запрос содержит некий набор данных(Array), соотв это будет либо массив массивов либо массив хэшей.

db.close # убираемся за собой)


puts
puts '                        Интерполяция/вставка в строку запрса. Безопасность от SQL Injection'

# SQL Injection - это если пользователь(хакер) введет 'DROP TABLE Cars -- и получит доступ к базе данных(???)
# https://stackoverflow.com/questions/13462112/inserting-ruby-string-into-sqliteS

require 'sqlite3'
db = SQLite3::Database.new 'test.sqlite'

# 1. Простая интерполяция строк. Небезопасный и уязвимый для хакеров вариант:
db.execute( "INSERT INTO Products ( stockID, Name ) VALUES ( #{id}, '#{name}' )" )
# Если строка окажется содержащей ', то это завершит строку в операторе SQL, что вызовет ошибку (или, что еще хуже, если злоумышленник сделает эксплойт SQL-инъекции). Cледует избегать попыток построить SQL-запрос путем интерполяции или добавления строк; вы можете подумать, что можете отфильтровать или процитировать неправильные символы, но на самом деле это довольно сложно сделать.

# 2. Безопасный вариант вставки переменых в строку запроса(фишка метода execute):
db.execute( "INSERT INTO Products ( stockID, Name ) VALUES ( ?, ? )", [id, name] ) # добавляем 2й аргумент со значениями
# так значения из массива будут подставляться в место со знаком вопроса, в том порядке в котором они идут в массиве

# Тот же синтаксис можно использовать и в SELECT запросах, если нужно
db.execute( 'SELECT * FROM Barbers WHERE name=?', [name] ) # тут передаем значение в условие WHERE

db.close


puts
puts '                                         Вывод данных из БД'

# 1й Способ(в виде массива). Для того чтоб сделать вывод из базы данных - нужно создать селект-запрос. Массив массивов неудобен если мы выводим не все столбцы в запрсе, тогда индексы в переменой вводить будет неудобно, тк они станут другими.
db = SQLite3::Database.new 'barbershop.db'
db.execute 'SELECT * FROM Users' do |row| # в row присвается каждая строка данного запроса в виде массива значений строки
	puts row #=> [1, 'Kroker', 9000]  # выводим все элементы массива
	puts row[1] #=> 'Kroker'  # тк row это массив то выводим только значение колонки с индексом 1
	puts "#{row[1]} #{row[3]}" # значения из нескольких столбцов
end
db.close


# 2й Способ(более удобный в виде хэша).
db = SQLite3::Database.new './DBS/barbershop.db'

db.results_as_hash = true  # используем сеттер метод results_as_hash(удобнее всего писать сразу после db = SQLite3::Dat...)

db.execute 'SELECT * FROM Users' do |row| # теперь наша переменная row клааса Hash а не Array и содержит ключами названия столбцов а значениями значения строки в этом столбце
  p row #=> {"id"=>1, "username"=>"Kroker", "phone"=>"657575", "datestamp"=>"2023-05-08T02:47", "barber"=>"Gus Fring", "color"=>"#25c137"}
	puts row['username'] # теперь можно выводить по ключу и не будет путаницы, если в запросе не все столбцы
	puts row['datestamp']
end
db.close












#
