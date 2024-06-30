puts '                                   ActiveRecord(на примере Sinatra)'

# ORM (англ. Object-Relational Mapping, рус. объектно-реляционное отображение, или преобразование) — технология программирования, которая связывает базы данных с концепциями объектно-ориентированных языков программирования, создавая «виртуальную объектную базу данных».

# Active record (AR) — шаблон проектирования приложений, описанный Мартином Фаулером в книге Patterns of Enterprise Application Architecture («Шаблоны архитектуры корпоративных приложений»). AR является популярным способом доступа к данным реляционных баз данных в объектно-ориентированном программировании.

# Схема Active Record — это подход к доступу к данным в базе данных. Таблица базы данных или представление обёрнуты в классы. Таким образом, объектный экземпляр привязан к единственной строке в таблице. После создания объекта новая строка будет добавляться к таблице на сохранение. Любой загруженный объект получает свою информацию от базы данных. Когда объект обновлён, соответствующая строка в таблице также будет обновлена. Класс обёртки реализует методы средства доступа или свойства для каждого столбца в таблице или представлении.

# ActiveRecord - это специальный гем для Ruby, он позволяет работать с БД как с обычными классами Руби, те вместо написания SQL-запросов мы можем писать рубикод-запросы(хотя и обычные SQL-запросы писать тоже можно)

ActiveRecord::Base.connection.execute('LONG SQL REQUEST') # запрос на чистом SQL

# https://guides.rubyonrails.org/active_record_querying.html   -   справка по активрекорд

# Механизмы миграции - чтобы версия базы данных всегда совпадала с версией кода.
# to keep up to date - держать в актуальном состоянии - чтобы работали предыдущие версии программы нужно чтоб БД тоже откатилась тк в новых версияхз они могли измениться, например добавить колонки
# При миграции базы данных создаются непосредственно из самого приложения


puts
puts '                                       Gemfile и Gemfile.lock'

# Gemfile для приложений Синатры с ActiveRecord:
source "https://rubygems.org"

gem 'sinatra', '~> 3.0'
gem 'sinatra-reloader', '~> 1.0'
gem 'sinatra-contrib', '~> 3.0' # этот гем содержит sinatra-reloader(это тоже можно поместить в group :development)
gem "sqlite3"
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"

group :development do # означает, что когда мы зальем приложение на хостинг, будет понятно что этот гем нужен исключительно для разработки, а не для работы приложения, поэтому в продакшен режиме он будет пропущен
  gem "tux" # (! Могут быть проблемы на Руби версий 3.2 и выше)
end
# bundle install  - установка из активной директории в которой лежит Gemfile (может немного тупить) Устанавливает те версии гемов которых у нас нет, сообщает о тех что уже есть.

# После установки в фаиле Gemfile.lock (Нужно создать заранее??) появятся записи. Они нужны для того чтоб в нашем приложении не было конфликта различных версий гемов(в этом фаиле были внесены и залочены определенные версии гемов)

# bundle update  -  иногда просит для совместимости версий

# bundle exec ruby app.rb  -  запуск приложения с гемами из Gemfile.lock


puts
puts '                                               app.rb'

# 1. Подключенеие в основном фаиле приложения например app.rb
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

# 2. Подключение БД в ActiveRecord. После строк с require в начале app.rb пишем это
set :database, { adapter: 'sqlite3', database: 'barbershop_ac.db' } # аналог для SQLite3::Database.new 'barbershop_ac.db'
# adapter: 'sqlite3' - это используемая СУБД
# database: 'barbershop_ac.db' - наша БД
# (В старых версиях было set :database, "sqlite3:barbershop.db")

# 3. Создадим модель - класс который будет, взаимодействовать с одноименной(тут clients) таблицей и представлять нашу сущность(entity). Примеры сущностей: клиент, парикмахер, статья, комментарий. Экземпляры модели это описание на Руби строк из этой таблицы, создаются либо методами класса модели в виде колекций, либо через new. Класс сущности называется в единственном числе, тк объекты класса сущности будут содержать иформацию об одном экземпляре сущности(тут о конкретном клиенте) те о том что будет находится в одной строке БД.
class Client < ActiveRecord::Base # создаем сущность "клиент": создаем класс который будет наследовать из класса Base модуля ActiveRecord все необходимые методы для работы с БД, те произошла настройка ActiveRecord для нашей сущности
end


puts
puts '                                          rake, Rakefile, миграции'

# При помощи rake мы будем создавать таблицы(и их миграции) с нашими сущностями и управлять ими.

# https://github.com/krdprog/rubyschool-notes/blob/master/one-by-one/lesson-29.md    Для Линукс ?

# Миграция - это очередная версия нашей базы данных. По аналогии с Git где существуют версии всего приложения +- тоже существует и для БД. У нас будут существовать различные версии наших БД и они будут вместе с кодом переходить из одной версии в другую.

# Rakefile(rakefile, rakefile.rb, Rakefile.rb) - произошёл от СИшного Makefile(заменили M на R - мэйкфаил руби). В этот руби-фаил прописываются определенные команды, которые мы можем исполнить. Он подключает различные нэймспэйсы. Он нужен для команды rake при помощи которой мы делаем миграцию.

# нужно создать Rakefile в основном каталоге приложения

# В Rakefile мы записываем:
require "./app"                      # подключаем/загружаем основной фаил приложения, тут app.rb
require "sinatra/activerecord/rake"  # подключаем нэймспэйс из гема активрекорд (подключаем ActiveRecord с командами rake для Синатры)


# Команды rake в консоли (Работает только при наличии Rakefile):
rake -T                     # список всех команд
rake db:create_migration NAME=name_of_migration  # создаёт новую миграцию в db/migrate/ с параметром - NAME=name_of_migration (parameters: NAME, VERSION)
rake db:migrate             # применяет (выполняет) созданную миграцию
rake db:rollback            # откат последней миграции
# Остальные команды:
rake db:create              # Creates the database from DATABASE_URL or con...
rake db:drop                # Drops the database from DATABASE_URL or confi...
rake db:encryption:init     # Generate a set of keys for configuring Active...
rake db:environment:set     # Set the environment value for the database
rake db:fixtures:load       # Loads fixtures into the current environment's...
rake db:migrate:down        # Runs the "down" for a given migration VERSION
rake db:migrate:redo        # Rolls back the database one migration and re-...
rake db:migrate:status      # Display status of migrations
rake db:migrate:up          # Runs the "up" for a given migration VERSION
rake db:prepare             # Runs setup if database does not exist, or run...
rake db:reset               # Drops and recreates all databases from their ...
rake db:schema:cache:clear  # Clears a db/schema_cache.yml file
rake db:schema:cache:dump   # Creates a db/schema_cache.yml file
rake db:schema:dump         # Creates a database schema file (either db/sch...
rake db:schema:load         # Loads a database schema file (either db/schem...
rake db:seed                # Loads the seed data from db/seeds.rb
rake db:seed:replant        # Truncates tables of each database for current...
rake db:setup               # Creates all databases, loads all schemas, and...
rake db:version             # Retrieves the current schema version number


puts
puts '                                             tux'

# (! Могут быть проблемы на Руби версий 3.2 и выше)

# tux - это утилита и консоль для ActiveRecord, которая позволяет управлять БД при помощи синтаксиса Руби

# gem install tux - устанавливает утилиту tux

# config.ru - создается в основной директории. Этот фаил нужен для утилиты/гема tux. При развертывании/deploy/deployment/залив на хостинг приложения этот фаил будет учитываться хостингом. Фаил содержит команды:
require './app'
run Sinatra::Application
# так же он запускает Руби чтобы он работал в tux, соотв мы можем его использовать для методов экземпляров модели


# tux (в консоли) - вход в текстовое меню утилиты tux
# exit (в консоли внутри утилиты) - выйти из текстового меню tux


puts
puts '                                       Создание миграций'

# 1. Убеждаемся что есть все гемы(гемлист или просто). Создаем и заполняем фаилы: Rakefile и config.ru

# 2. Заполняем app.rb и создаем модель как выше

# 3. Создаем фаил миграции - Вводим в консоли:
rake db:create_migration NAME=create_clients # пишем маленькими буквами без пробелов
# clients - название миграции и таблицы, оно должно быть таким же как название модели только во множественном числе
#=> db/migrate/20230523033236_create_clients.rb  # У нас в приложении создаются данные каталоги с данным rb фаилом
# 20230523033236 - дата и время создания фаила, чтоб миграции с одинаковыми именами отличались
# Содержание фаила 20230523033236_create_clients.rb (то что заполнено автоматически):
class CreateClients < ActiveRecord::Migration[7.0]
  # CreateClients - класс нашей миграции унаследовавший методы из ActiveRecord::Migration[7.0]
  def change # метод созданный ActiveRecord, для того чтобы мы в нем создали миграцию(раньше вместо него было 2 метода: up и down)
  end
end
# Если до запуска миграции хотим исправить название фаила то можно спокойно менять эту create_clients часть руками в самом имени фаила и внутри фаила соответсвенно

# 4. Заполняем тело метода change(создаем макет таблицы):
class CreateClients < ActiveRecord::Migration[7.0]
  def change

    create_table :clients do |t| # оператор метода create_table принимает параметр с названием таблицы(обязательно во множественном числе) и блок в котором мы задаем столбцы, присваивая в переменную t имя таблицы. При запуске миграции сработает запрос CREATE TABLE IF NOT EXISTS "Users" ...

      # id INTEGER PRIMARY KEY AUTOINCREMENT - будет создан автоматически, это будет ключевое поле с прикрепленным к нему индексом, но можно подключить опцию, чтобы он не создавался
      t.text :name       # метод text от объекта t принимает параметр с названием колонки в виде символа
      t.text :phone      # теперь в таблице clients будет создан столбец phone с типом TEXT
      t.text :datestamp
      t.text :barber
      t.text :color

      # Типы столбцов в ActiveRecord:
      # https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html
      # :primary_key, :string -> VARCHAR(255), :text -> TEXT, :integer, :bigint, :float, :decimal, :numeric, :datetime, :time, :date, :binary, :blob, :boolean

      t.timestamps # создаст 2 дополнительных столбца/поля created_at и updated_at с типом данных datetime - дата создания и обновления сущности, обновляются автоматически при добавлении или изменении сущности
      # Если данные поля нам не нужны, то можно просто убрать тут эту запись, до запуска миграции
    end

  end
end

# 5. Запускаем миграцию(запускает сразу все неисполненные миграции)
rake db:migrate
# появляется фаил barbershop_ac.db(если его еще не было) который содержит таблицу clients, а так же автоматически созданная таблица schema_migrations которая содержит столбец версий миграций например 20230523033236; а так же еще какуюто служебную таблицу с колонками: key, value, created_at, updated_at
# Так же создался фаил db/schema.rb содержащий актуальное состояние всех таблиц в БД

# Мы настроили mapping (ORM - Object Relational Mapper) Связка ООП с реляционными БД


puts
puts '                               Создание таблицы с начальными данными'

# Создание еще одной таблицы - barbers. Заполнение талицы начальными данными

# Добавляем в app.rb:
class Barber < ActiveRecord::Base
end

# Создаём миграцию:
# > rake db:create_migration NAME=create_barbers

# создаём таблицу и вносим данные в db/migrate/20230523045630_create_barbers.rb
class CreateBarbers < ActiveRecord::Migration[7.0]
  def change

    create_table :barbers do |t|
      t.text :name
      t.timestamps
    end

    # Наполнение таблицы данными:
    Barber.create :name => 'Jessie Pinkman'  #=> Создаем экземпляр модели, который потом создаст соответсвующую строку в таблице
    # create - метод который сразу создает строку в таблицк
    # :name - ключ хэша и название столбца в котором будут заполнены данные
    # 'Jessie Pinkman' - значение хэша, это значение в строке этого столбца
    Barber.create :name => 'Walter White'
    Barber.create :name => 'Gus Fring'
    Barber.create :name => 'Mike Ehrmantraut'

  end
end

# Запустим миграцию:
rake db:migrate
# теперь у нас в БД создана таблица barbers содержащая заданные строки


puts
puts '                                     Методы AR для работы с сущностями'

# Эти методы Руби можно использовать в app и представлениях, а так же как команды в консоли внутри утилиты tux.


# 1. Some.create - Сразу создает и объект и строку в БД:
Barber.create :name => 'Vasya' #=> INSERT INTO "barbers" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Vasya"], ["created_at", "2023-05-26 03:36:34.271601"], ["updated_at", "2023-05-26 03:36:34.271601"]]

# 2. Some.new/some.save - new создает только объект в памяти и чтобы данные из него сохранить в БД нужно выполнить еще метод save.
b = Barber.new :name => 'Petya' #=> #<Barber id: nil, name: "Petya", created_at: nil, updated_at: nil>.
b.new_record? #=> true  # проверяет новая ли(не сохранена в БД) запись в переменной b
b.save # по умолчанию проводит валидацию и создает или заменяет строку в таблице #=> INSERT INTO "barbers" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Petya"], ["created_at", "2023-05-26 03:49:05.241644"], ["updated_at", "2023-05-26 03:49:05.241644"]]
b.update :name => 'Vasya' #=> изменит только данноое значение, вся остальная строка останется. save тут уже не нужно
b.destroy #=>  удалить строку


# Методы модели(методы класса) для раты с БД:

# узнать какие свойства(поля) у сущности
Contact.attribute_names #=> ["id", "email", "message", "created_at", "updated_at"]

Client.all #=> SELECT "clients".* FROM "clients"  # коллекция экземпляров Client описывающих все строки в таблице clients в виде объекта класса ActiveRecord::Relation (если не создана(или нет рэйкфаила??) выдаст ошибку)

Barber.count #=> 4 - Количество сущностей Barber в таблице barbers(SELECT COUNT(*) FROM "barbers")

# find - поиск по ключу, вызовет ошибку если запись не будет найдена
Customer.find(10) #=> #<Customer id: 10, first_name: "Ryan">  # SELECT * FROM customers WHERE (customers.id = 10) LIMIT 1
# -- find для запроса нескольких объектов передайте массив первичных ключей. Возврат будет массивом
Customer.find([1, 10]) #=> [#<Customer id: 1, first_name: "Lifo">, #<Customer id: 10, first_name: "Ryan">] # SELECT * FROM customers WHERE (customers.id IN (1,10))
Customer.find(1, 10) # альтернатива

# -- find_by поиск по значению любого столбца(выводит только 1 запись, тк применяет LIMIT ``)
Customer.find_by first_name: 'Lifo'  #=> #<Customer id: 1, first_name: "Lifo"> или nil

# -- where (любое SQL условие). Выводит уже все записи удовлетворяющие условию
Comment.where("post_id = ?", params[:post_id]) #=> возвращает объект похожий массив(но не совсем массив) объектов или пустой

# -- order вывод в порядке по убыванию или возрастанию относительно столбцов
Barber.order "created_at DESC" # получаем всю таблицу barbers(SELECT * FROM barbers ORDER BY created_at DESC) отсортированную по полю created_at и DESC переданные параметром в виде строки через пробел.

# Чейнинг - запись методов подряд(но нужно чтобы возвращали то что подходит ??)
Answer.where(question: @question).limit(2).order(created_at: :desc)


puts
puts '                                    Вывод данных из БД в представления'

# Вывод становится намного проще тк нам больше не нужно думать о подключении БД в каждый метод, тк она подключена на весь фаил при помощи activerecord

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'barbershop_ac.db' }

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end


before do
	@barbers = Barber.all # используем запрос для всех обработчиков(втч Сохранение данных из формы)
end

get '/' do
	erb :hq_barbershop_index
end

# Обработчик однотипных страниц: если список парикмахеров на главной странице со ссылками
get '/barber/:id' do
  @barber = Barber.find(params[:id]) # params[:id] принимает значение из URL
  erb :hq_barbershop_barber
end


puts
puts '                                    Сохранение данных из формы'

# 1. Сохранение данных в БД через отдельные параметры атрибута name (ламерский способ)
get '/visit' do
	erb :hq_barbershop_visit
end

post '/visit' do
	@username = params[:username]
	@phone    = params[:phone]
	@datetime = params[:datetime]
	@barber   = params[:barber]
	@color    = params[:color]

  # а. Сохранение через Client.create(хэш) - Записываем новые данные в БД(Создаем новую сущность клиента и вводим данные в БД через параметр-хэш, где значения ключей это названия столбцов в фаиле миграции)
  Client.create(name: @username, phone: @phone, datestamp: @datetime, barber: @barber, color: @color)

  # б. Сохранение через Client.new в столбик
  c = Client.new
  c.name = @username
  c.phone = @phone
  c.datestamp = @datetime
  c.barber = @barber
  c.color = @color
  c.save

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end


# 2. Сохранение данных в БД через общий параметр-хэш (тру способ)
get '/visit' do
  # Чтобы данный способ работал нужно изменить значения атрибутов name в виде hq_barbershop_visit_true
	erb :hq_barbershop_visit_true
end

post '/visit' do
  c = Client.new params[:client] # Вместо client можно написать что угодно(главное в виде написать тоже самое название  client[имя_столбца]). В итоге мы получаем хэш со всеми значениями полей миграции.
  # К нам на сервер так и передается например 'client[name]' потом уже обрабатывается и получается хэш(в классе Client ??)
  # params[:client] = name: 'Имя', phone: '98766876', datestamp: 'дата', barber: 'Вася', color: '#6d7a80'
  c.save

	erb :hq_barbershop_visit_true
end


puts
puts '                                       Валидации. Метод validates'

# https://guides.rubyonrails.org/active_record_validations.html  -   Active Record Validations — Ruby on Rails Guides

# Метод save по умолчанию проводит и валидацию, если всё соответсвует требованиям валидации, то возвращает true иначе false.

# Хоть валидация и выполняется автоматически, но нужно настроить ее требования(тк по умолчанию их нет) в модели, к которой относятся данные при помощи метода validates. Настройки могут позволить проводить валидацию по различным параметрам: длинна строки, значение строки итд.

class Client < ActiveRecord::Base
  validates :name, presence: true  # проверка на то чтобы значение поля name не было пустым
  # :name - название столбца для проверки
  # presence: true -  хэш с условиями проверки.
  validates :phone, presence: true, length: { minimum: 6 }  # можжно делать по нескольким типам проверки сразу
  validates :datestamp, presence: true
  validates :color, presence: true

  #                           Некоторые другие популярные методы проверки:

  # length - проверяем по допустимой длинне
  validates :name, length: { minimum: 2 }             # minimum - длинна не менее чем(можно указать одновременно с maximum)
  validates :bio, length: { maximum: 500 }            # maximum - длинна не более чем(можно указать одновременно с minimum)
  validates :password, length: { in: 6..20 }          # in - допустимая длинна находится в интервале
  validates :registration_number, length: { is: 6 }   # is - точное указание длинны

  # inclusion - проверяем по наличию необходимой подстроки(имэил лучше всего проверять по наличию '@')
  validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }

  # numericality - проверка, введены ли в поле числа
  validates :some, numericality: true
end
# если больше ничего не добавлять для валидации в программе, то будет просто не сохранять в БД, если проверка не пройдена, те метод вернул false, но чтобы ошибка както отображалась, нужно это дополнительно проверить.

# Если мы проверим незаполненного клиента в tux то:
c = Client.new     #=> #<Client id: nil, name: nil, phone: nil, datestamp: nil, barber: nil, color: nil, created_at: nil, updated_at: nil>
c.valid?           #=> false
# Все ошибки можно выводить на экран при помощи специального массива errors:
c.errors.count     #=> 4 - выводит число незаполненных полей(ошибок)
c.errors.messages  #=> {:name=>["can't be blank"], :phone=>["can't be blank"], :datestamp=>["can't be blank"], :color=>["can't be blank"]} - выводит сообщения об ошибках, мы можем использовать ее для вывода
# Эти свойства мы так же можем использовать в обработчиках и методах основной программы.

class Barber < ActiveRecord::Base
end

before do
	@barbers = Barber.all
end

# Валидация и вывод сообщения об ошибке
get '/visit' do
  @c = Client.new # создаем пустой объект(все значения равны nil) для того чтобы использовать их в values в представлении.
	erb :hq_barbershop_visit_true
end

post '/visit' do
	@c = Client.new params[:client] # делаем переменную глобальной, чтобы отображалась в представлении

  if @c.save # валидация проводится по условиям из модели, вносит или не вносит Client.new в базу и возвращает true или false
    redirect to '/visit'
	else
    # В значения временной сущности добавляются пустые строки в незаполненных столбцах(??)

    @error = @c.errors.full_messages.first #=> из хэша ошибок(errors) вернет массив значений(["Name can't be blank", "Phone can't be blank"]) и выберет из них первую, тоесть сообщит о первом из незаполненных полей.
    # ?? почемуто(изза повершелл) выводит в массиве каждое сообщение по 3 раза

		erb :hq_barbershop_visit_true
	end
end


puts
puts '                           Значения по умолчанию у столбца в миграции'

# На примере Pizzashop

# 1. содержание основного фаила
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'pizzashop.db' }

class Product < ActiveRecord::Base
end

# 2. миграция для создания таблицы с пицами
# > rake db:create_migration NAME=create_products
class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.decimal :size, default: 20 # установка значения по умолчанию ключевым словом default
      t.boolean :is_spicy
      t.boolean :is_veg
      t.boolean :is_best_offer
      t.string :path_to_image

      t.timestamps
    end
  end
end
# > rake db:migrate


puts
puts '                              Seed database. Миграция добавления add_'

# Seed database - наполнение базы данных начальными значениями

# 1. Миграция добавления, в отдельном фаиле заполняет уже созданную до того таблицу. Ее названия начинаются с Add
# > rake db:create_migration NAME=add_products
# добавляется db/migrate/786238472_add_products.rb

# 2. Заполняем фаил миграции - создаем в нем сущности.
class AddProducts < ActiveRecord::Migration[7.0]
  def change
    # синтаксис метода create требует: либо указания хотя бы 1го аргумента после вызова метода; либо чтоб начать аргументы с новой строки нужно взять их в круглые скобки. А иначе 1м аргументом будет считаться \n что вызовет ошибку.
    Product.create :title => 'Гавайская',
      :description => 'Это гавайская пицца',
      :price => 350,
      :size => 30,
      :is_spicy => false,
      :is_veg => false,
      :is_best_offer => false,
      :path_to_image => '/images/01.jpg'
    # тут пишем путь к картинке в нашем приложении, чтобы потом добавить его в тег картинки img так: <img src="<%= pizza.path_to_image %>">

    Product.create (
      :title => 'Пепперони',
      :description => 'Это пицца Пепперони',
      :price => 450,
      :size => 30,
      :is_spicy => false,
      :is_veg => false,
      :is_best_offer => true,
      :path_to_image => '/images/02.jpg'
    )
    # Если нам нужно 2 картинки большую и маленькую для разных страниц, то лучше добавить в таблицу еще одну колонку например тут :path_to_big_image, это будет лучше чем уменьшать большие картинки на странице, тк это уменьшит нагрузку на станицу и не будет замедлять ее работу
  end
end

# 3. Запускаем миграцию
# > rake db:migrate
# В фаиле schema.rb изменяется только номер version: 2023_06_13_060331


puts
puts '                              Форма со скрытым полем(использование JS)'

# На примере Pizzashop - форма для отправки заказов

# Фаил для jS скриптов создаем в папке public (можно сделать там и отдельную подпапку например scripts) например script.js и подключаем так <script src="/script.js"></script> в layout.erb


# Модель для клиентов(и выполняем для нее миграцию естественно)
class Client < ActiveRecord::Base
end

# Заполнение основного вида
get '/' do
	@products = Product.all
	erb :pizzashop_index
end

# Выделим "product_1=4,product_2=7,product_3=4," разбивку в метод(хэлпер):
# Это не эффективный способ, лучше использовать json (позволяет поддерживать формат данных любой сложности).
def parse_orders_input(orders_input) #"product_1=4,product_2=7,product_3=4,"
  orders_input.split(',')
              .map{|prod| prod.split(/[_=]/)}
              .map{|a| [a[1], a[2]]} # => [["1", "4"], ["2", "7"], ["3", "4"]]
              .map{|k, v| [Product.find(k.to_i), v.to_i]} #=> [[obj1, 4], ...]
              .to_h #=> {obj1 => 4, ...} тоесть хэш где ключ сущность, а значение число заказов на нее
end

# Тот случай когда только пост-обработчик. Тк для приема списка заказов пользователь только нажимает кнопку на главной странице, а данные берутся из локалсторэдж.
post '/cart' do
  @c = Client.new

	@order_code = params[:orders] # "product_1=4,product_2=7,product_3=4,"

  return erb "Cart is empty" if @order_code.size == 0 # Если пустой локалсторедж

	@order_list = parse_orders_input(params[:orders]) # парсим строку заказов в хэлпере

	erb :pizzashop_cart
end

# обработчик подтверждения заказа и занесения в бд(мб сделать не отдельный чтобы легче валидация?)
post '/order' do
	@c = Client.new params[:client]
	@c.save
	erb :pizzashop_order_plased
end


puts
puts '                                       Минусы которые можно исправить'

# Минусы созданного PizzaShop(и других программ в конспектах по Синатре):
# 1. Модели находятся в app.rb. Лучше вынести в отдельный каталог, каждая модель в отдельном фаиле.
# 2. Много несвязанных между собой get, post в одном файле. Синатра позволяет разбить по разным фаилам(потом мб доучить)
# 3. Вспомогательный метод (хелпер) в этом же app.rb
# 4. Представления не в подкаталогах (как в рейлс)
# 5. Бардак с url
# 6. Нет тестов



















#
