puts '                                  ActiveRecord(на примере Sinatra)'

# ActiveRecord - это специальный гем для Ruby, который делает работу с БД более удобной и быстрой

# https://guides.rubyonrails.org/active_record_querying.html   -   справка по активрекорд(Active Record Query Interface — Ruby on Rails Guides)

# Механизмы миграции - чтобы версия базы данных всегда совпадала с версией кода.
# to keep up to date - держать в актуальном состоянии - чтобы работали предыдущие версии программы нужно чтоб БД тоже откатилась тк в новых версияхз они могли измениться, например добавить колонки
# При миграции базы данных создаются непосредственно из самого приложения


puts
puts '                                       Gemfile и Gemfile.lock'

# Gemfile нужен для установки зависимостей ??

# Gemfile для приложений Синатры с ActiveRecord
source "https://rubygems.org"

gem 'sinatra', '~> 3.0'
gem 'sinatra-reloader', '~> 1.0'
gem 'sinatra-contrib', '~> 3.0' # этот гем содержит sinatra-reloader(на самом деле это тоже разработческий гем и соотв можно поместить в group :development и его тоже)
gem "sqlite3"
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"

group :development do # означает, что когда мы зальем приложение на хостинг, будет понятно что этот гем нужен исключительно для разработки, а не для работы приложения, поэтому в продакшен режиме он будет пропущен
  gem "tux"
end
# bundle install  - установка(из активной директории в которой лежит Gemfile)(может немного тупить) Устанавливает те версии гемов которых у нас нет, сообщает о тех что уже есть.

# После установки в фаиле Gemfile.lock (Нужно создать заранее??) появятся записи. Они нужны для того чтоб в нашем приложении не было конфликта различных версий гемов(в этом фаиле были внесены и залочены определенные версии гемов)

# bundle update  -  иногда просит для совместимости версий

# (bundle exec ruby app.rb)


puts
puts '                                           Содержание app.rb'

# 1. Подключенеие в основном фаиле приложения например app.rb
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord' # подключение гема activerecord

# 2. после строк подключения пишем это в начале app.rb
set :database, { adapter: 'sqlite3', database: 'barbershop_ac.db' } # так в ActiveRecord создается подключение к БД(аналог для SQLite3::Database.new 'barbershop_ac.db'), где adapter: 'sqlite3' это используемая СУБД, а 2й аргумент наша БД
# (В старых версиях было set :database, "sqlite3:barbershop.db")

# 3. Создадим модель - класс который будет представлять нашу сущность(entity). Модель/сущность описывает наши события/строки в таблице(тут clients) - то с чем мы работаем(примеры сущностей: клиент, парикмахер, пост в блоге, комментарий итд). Класс сущности называется в единственном числе, тк объекты класса сущности будут содержать иформацию об одном экземпляре сущности(тут о конкретном клиенте) те о том что будет находится в одной строке БД.
class Client < ActiveRecord::Base # тут создаем сущность "клиент": создаем класс который будет наследовать у ActiveRecord::Base
  # класс унаследовал все необходимые методы для работы с БД из класса Base модуля ActiveRecord, те произошла настройка ActiveRecord для нашей сущности
end


puts
puts '                                          rake, Rakefile, миграции'

# При помощи rake мы будем создавать таблицы(и их миграции) с нашими сущностями и управлять ими.

# Миграция - это очередная версия нашей базы данных. По аналогии с Git где существуют версии всего приложения +- тоже существует и для БД. У нас будут существовать различные версии наших БД и они будут вместе с кодом переходить из одной версии в другую, как раз при помощи механизма миграций

# Rakefile(rakefile, rakefile.rb, Rakefile.rb) - произошёл от СИшного Makefile(заменили M на R - мэйкфаил руби). В этот руби-фаил прописываются определенные команды, которые мы можем исполнить. Он подключает различные нэймспэйсы. Он нужен для команды rake при помощи которой мы делаем миграцию.

# нужно создать Rakefile в основном каталоге приложения

# В Rakefile мы записываем:
require "./app"   #=> подключаем/загружаем основной фаил приложения, тут app.rb
require "sinatra/activerecord/rake"  #=> подключаем нэймспэйс из гема активрекорд (подключаем ActiveRecord с командами rake для Синатры)

# ---------------------------- Для Линукс ? --------------------------------------------------------
# Из https://github.com/krdprog/rubyschool-notes/blob/master/one-by-one/lesson-29.md
# --------------------------------------------------------------------------------------------------

# Команды rake (в консоли) (Работает только при наличии Rakefile):
rake -T  # список команд(тех что ниже)
rake db:create_migration NAME=name_of_migration  # создаёт новую миграцию в db/migrate/ где параметр (тут для примера) - NAME=name_of_migration (parameters: NAME, VERSION)
rake db:migrate  # применяет (выполняет) созданную миграцию: # Migrate the database (options: VERSION=x, VER...
rake db:rollback  # возврат к предыдущей миграции: # Rolls the schema back to the previous version...
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


# Пример создания простой миграции:

# 1. Убеждаемся что есть все гемы(гемлист или просто). Создаем и заполняем фаилы: Rakefile и config.ru

# 2. Заполняем app.rb и создаем модель/сущность как выше с именем как будет в нашей миграции только в единств числе

# 3. Создаем фаил миграции - Вводим в консоли:
rake db:create_migration NAME=create_clients #(пишем маленькими буквами без пробелов; clients - название миграции и таблицы, оно должно быть таким же как название модели только во множественном числе)
#=> db/migrate/20230523033236_create_clients.rb  # У нас в приложении создаются данные каталоги с данным rb фаилом
# 20230523033236 - дата и время создания фаила(специально чтоб миграции с одинаковыми именами отличались)
# Содержание фаила 20230523033236_create_clients.rb (то что заполнено автоматически):
class CreateClients < ActiveRecord::Migration[7.0]
  # CreateClients - класс нашей миграции унаследовавший методы из ActiveRecord::Migration[7.0]
  def change # метод созданный ActiveRecord, для того чтобы мы в нем создали миграцию (раньше вместо него в миграциях было 2 метода: up и down)
  end
end
# Если до запуска миграции хотим исправить название фаила то можно спокойно менять эту create_clients часть руками в самом имени фаила и внутри фаила соответсвенно

# 4. Заполняем тело метода change(создаем макет таблицы):
class CreateClients < ActiveRecord::Migration[7.0]
  def change
    # далее аналог: db.execute 'CREATE TABLE IF NOT EXISTS "Users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "datestamp" TEXT, "barber" TEXT, "color" TEXT)'
    create_table :clients do |t| # Метод(вызов) create_table принимает в виде символа параметр с названием таблицы(название таблицы обязательно во множественном числе) присваивает в переменную t и далее лямбду в которой мы задаем столбцы

      # столбец id INTEGER PRIMARY KEY AUTOINCREMENT будет создан автоматически

      t.text :name       # метод text от объекта t принимает параметр с названием колонки в виде символа
      t.text :phone      # теперь в таблице clients будет создан столбец phone с типом TEXT
      t.text :datestamp
      t.text :barber
      t.text :color

      # типы столбцов в ActiveRecord:
      # text -> TEXT
      # string -> VARCHAR(255)
      # ...
      # :primary_key, :string, :text, :integer, :bigint, :float, :decimal, :numeric, :datetime, :time, :date, :binary, :blob, :boolean
      # https://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html

      t.timestamps # создаст 2 дополнительных столбца created_at и updated_at - дата создания и обновления сущности, заполняются автоматически при добавлении или изменении сущности
    end
  end
end

# 5. Запускаем миграцию(запускает сразу все неисполненные миграции)
rake db:migrate
# появляется фаил barbershop_ac.db(если его еще не было) который содержит таблицу clients, а так же автоматически созданная таблица schema_migrations которая содержит столбец версий миграций например 20230523033236; а так же еще какуюто служебную таблицу с колонками: key, value, created_at, updated_at
# Так же создался фаил db/schema.rb содержащий все наши миграции ??

# Мы настроили mapping (ORM - Object Relational Mapper) Связка ООП с реляционными БД


puts
# Создание еще одной таблицы - barbers. Заполнение талицы начальными данными

# Добавляем в app.rb:
class Barber < ActiveRecord::Base
end

# Создаём миграцию:
rake db:create_migration NAME=create_barbers

# создаём таблицу и вносим данные в db/migrate/20230523045630_create_barbers.rb
class CreateBarbers < ActiveRecord::Migration[7.0]
  def change

    create_table :barbers do |t|
      t.text :name
      t.timestamps
    end

    # Наполнение таблицы данными:
    Barber.create :name => 'Jessie Pinkman'  #=> Создаем экземпляр класса сущности в таблице с данными задаваемыми параметрами метода create, в виде хэша где ключ это имя столбца а значение это значение в строке этого столбца
    Barber.create :name => 'Walter White'
    Barber.create :name => 'Gus Fring'
    Barber.create :name => 'Mike Ehrmantraut'

  end
end

# Запустим миграцию:
rake db:migrate
# теперь у нас в БД создана таблица barbers содержащая заданные строки


puts
puts '                                           Методы для создания сущности'

# 1. Some.create - Сразу создает объект уже в базе данных:
Barber.create
# Этот метод лучше подходит для изначального заполения БД со стороны сервера.

# 2. Some.new - Создает объект только в памяти и чтобы его сохранить в БД нужно выполнить еще метод save:
b = Barber.new
b.save


puts
puts '                                                   tux'

# tux - это утилита и консоль для ActiveRecord, которая позволяет управлять БД при помощи синтаксиса Руби

# gem install tux - устанавливает утилиту tux

# В приложении(Синатра) в основной директории есть фаил config.ru. Этот фаил нужен для утилиты/гема tux. При развертывании/deploy/deployment/залив на хостинг приложения этот фаил будет учитываться хостингом. Фаил содержит команды:
require './app'
run Sinatra::Application
# так же он запускает Руби чтобы он работал в tux, соотв мы можем его использовать для методов для модели


# tux (в консоли) - вход в текстовое меню утилиты tux (чем-то похоже на меню для sqlite3)
# exit (в консоли внутри утилиты) - выйти из текстового меню tux

# Команды Руби в консоли внутри утилиты tux, а так же в app и представлениях:
Client.all #=> Список всех сущностей в БД в таблице clients в виде объекта класса ActiveRecord::Relation содержащего в виде массива список объектов Client (SELECT "clients".* FROM "clients") (если не создана(или нет рэйкфаила??) выдаст ошибку)
Barber.count #=> 4 - Количество сущностей Barber в таблице barbers(SELECT COUNT(*) FROM "barbers")
Barber.create :name => 'Vasya' #=> заполняем таблицу новой сущностью при помощи create (INSERT INTO "barbers" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Vasya"], ["created_at", "2023-05-26 03:36:34.271601"], ["updated_at", "2023-05-26 03:36:34.271601"]])
b = Barber.new :name => 'Petya' #=> #<Barber id: nil, name: "Petya", created_at: nil, updated_at: nil>. создаем объект в памяти, если больше ничего не делать то он никуда не сохранится, если выйти из tux то объект исчезнет
b.new_record? #=> true  # проверяет новая ли запись в переменной b(не сохранена в БД)
b.save #=> по умолчанию проводит валидацию и вносит(создает или заменяет) Barber.new в таблицу (INSERT INTO "barbers" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Petya"], ["created_at", "2023-05-26 03:49:05.241644"], ["updated_at", "2023-05-26 03:49:05.241644"]])

# -- find - получить объект, соответствующий указанному первичному ключу
# SELECT * FROM customers WHERE (customers.id = 10) LIMIT 1
Customer.find(10) #=> #<Customer id: 10, first_name: "Ryan">   # вызовет ошибку если запись не будет найдена
# -- find для запроса нескольких объектов. Вызовите метод и передайте массив первичных ключей. Возврат будет массивом
# SELECT * FROM customers WHERE (customers.id IN (1,10))
Customer.find([1, 10]) #=> [#<Customer id: 1, first_name: "Lifo">, #<Customer id: 10, first_name: "Ryan">]
Customer.find(1, 10) # альтернатива
# Метод find вызовет исключение, если для всех предоставленных первичных ключей ActiveRecord::RecordNotFoundне будет найдена совпадающая запись

# -- find_by
Customer.find_by first_name: 'Lifo'  #=> #<Customer id: 1, first_name: "Lifo"> или nil

# -- where (любое SQL условие)
Comment.where("post_id = ?", params[:post_id]) #=> возвращает массив объектов или пустой

# -- order
Barber.order "created_at DESC" # получаем всю таблицу barbers(SELECT * FROM barbers ORDER BY created_at DESC) отсортированную по полю created_at и DESK переданные параметром в виде строки через пробел.


puts
puts '                                          Вывод в представления'

# Вывод становится намного проще тк нам больше не нужно думать о подключении БД в каждый метод, тк она подключена на весь фаил при помощи activerecord

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'barbershop_ac.db' }

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end


# Запись данных в таблицу
before do
	@barbers = Barber.all # используем запрос для всех обработчиков
end

get '/' do
	erb :hq_barbershop_index
end

get '/visit' do
	erb :hq_barbershop_visit
end

# 1. Сохранение через Client.create(хэш)
post '/visit' do
	@username = params[:username]
	@phone    = params[:phone]
	@datetime = params[:datetime]
	@barber   = params[:barber]
	@color    = params[:color]

  # Записываем новые данные в БД(Создаем новую сущность клиента и вводим данные в БД через параметр-хэш, где значения ключей это названия столбцов в фаиле миграции)
  Client.create(name: @username, phone: @phone, datestamp: @datetime, barber: @barber, color: @color)

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

# 2. Сохранение через Client.new в столбик(тоже ламерский способ)
post '/visit' do
	@username = params[:username]
	@phone    = params[:phone]
	@datetime = params[:datetime]
	@barber   = params[:barber]
	@color    = params[:color]

  c = Client.new
  c.name = @username
  c.phone = @phone
  c.datestamp = @datetime
  c.barber = @barber
  c.color = @color
  c.save

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

# 3. Сохранение данных в БД тру способом(без отдельных параметров и кучи переменных)
get '/visit' do
  # Чтобы данный способ работал нужно изменить значения атрибутов name в виде hq_barbershop_visit_true
	erb :hq_barbershop_visit_true
end

post '/visit' do
  c = Client.new params[:client] # Вместо client можно написать что угодно(главное в виде написать тоже самое название  client[имя_столбца]). В итоге мы получаем хэш со всеми значениями полей обозначенными названиями колонок БД для них.
  # К нам на сервер так и передается например 'client[name]' потом уже обрабатывается и получается хэш(в классе Client ??)
  # params[:client] = name: 'Имя', phone: '98766876', datestamp: 'дата', barber: 'Вася', color: '#6d7a80'
  c.save

	erb :hq_barbershop_visit_true
end


puts
puts '                                       Валидация и метод validates'

# https://guides.rubyonrails.org/active_record_validations.html  -   Active Record Validations — Ruby on Rails Guides

# Метод save по умолчанию проводит и валидацию, если всё правильно, то возвращает true иначе false.

# Хоть валидация и выполняется автоматически, но нужно ее настроить в основном фаиле app.rb в модели к которой относятся данные при помощи метода validates. Настройки могут позволить проводить валидацию по различным параметрам: длинна строки, значение строки итд.

class Client < ActiveRecord::Base
  validates :name, presence: true  # 1й параметр это название столбца для проверки, 2+ параметры это хэш с условиями проверки. В данном случае условие проверки presence: true означает, что значение для столбца name не должно быть пустым
  validates :phone, presence: true, length: { minimum: 6 }  # можжно делать по нескольким типам проверки сразу
  validates :datestamp, presence: true
  validates :color, presence: true

  #                           Некоторые другие популярные методы проверки:

  #     1. length - проверяем по допустимой длинне
  validates :name, length: { minimum: 2 }             # minimum - длинна не менее чем
  validates :bio, length: { maximum: 500 }            # maximum - длинна не более чем(можно указать одновременно с предыдущим)
  validates :password, length: { in: 6..20 }          # in - допустимая длинна находится в интервале
  validates :registration_number, length: { is: 6 }   # is - точное указание длинны

  #     2. inclusion - проверяем по наличию необходимой подстроки(имэил лучше всего проверять по наличию '@')
  validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }

  # numericality: true - проверка, введены ли числа

end
# если больше ничего не добавлять для валидации в программе, то будет просто не сохранять в БД, если проверка не пройдена, те метод вернул false и чтобы ошибка както отображалась, нужно это дополнительно проверить.

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
  @c = Client.new # создаем пустой объект(все значения равны nil) для того чтобы использовать в values представления.

	erb :hq_barbershop_visit_true
end

post '/visit' do
	@c = Client.new params[:client] # делаем переменную глобальной, чтобы отображалась в представлении

  if @c.save # валидация проводится по условиям из модели, вносит или не вносит Client.new в базу и возвращает true или false
		erb "<p>Thank you!</p>"
	else
    # В значения временной сущности добавляются пустые строки в незаполненных столбцах

    @error = @c.errors.full_messages.first #=> из хэша ошибок(errors) вернет массив значений(["Name can't be blank", "Phone can't be blank", "Name can't be blank", "Phone can't be blank", "Name can't be blank", "Phone can't be blank"] ?? почемуто 3 раза ??) и выберет из них первую, тоесть сообщит о первом из незаполненных полей.
		erb :hq_barbershop_visit_true
	end
end


puts
puts '                               Универсальные обработчики для однотипных страниц'

# Сделаем список парикмахеров на главной странице ссылками ведущими на отдельные страницы парикмахеров
before do
	@barbers = Barber.all
end

get '/' do
	erb :hq_barbershop_index    # тут будут ссылки на страницы парикмахеров
end

get '/barber/:id' do
  @barber = Barber.find(params[:id]) # params[:id] - как и раньше принимает значение из адреса обработчика
  erb :hq_barbershop_barber
end


# Теперь список записавшихся(так же)
get '/clients' do
  @clients = Client.order('created_at DESC')
  erb :hq_barbershop_clients
end

get '/clients/:id' do
  @client = Client.find(params[:id])
  erb :hq_barbershop_client
end


puts
puts '                         Значения по умолчанию у столбца в миграции. Миграция добавления add_'

# На примере Pizzashop

# 1 содержание основного фаила
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'pizzashop.db' }

class Product < ActiveRecord::Base
end

# 2 миграция для создания таблицы с пицами
rake db:create_migration NAME=create_products

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

rake db:migrate


puts
# Seed database - наполнение базы данных начальными значениями

# 1. Миграция добаления, в отдельном фаиле заполняет уже созданную до того миграцию таблицы. Ее названия начинаются с Add
rake db:create_migration NAME=add_products
# добавляется db/migrate/786238472_add_products.rb

# 2. Заполняем фаил миграции - создаем в нем сущности.
class AddProducts < ActiveRecord::Migration[5.2]
  def change

    # синтаксис метода create требует указания аргумента после вызова метода(тут 1й элемент хэша тк одного достаточно), а перевод строки считается окончанием инструкции, соотв для того чтоб начать аргументы с новой строки нужно взять их в круглые скобки(это уберет \n между методом и аргументом).
    Product.create :title => 'Гавайская',
      :description => 'Это гавайская пицца',
      :price => 350,
      :size => 30,
      :is_spicy => false,
      :is_veg => false,
      :is_best_offer => false,
      :path_to_image => '/images/01.jpg'      # тут пишем путь к картинке в нашем приложении, чтобы потом добавить его в тег картинки img так: <img src="<%= pizza.path_to_image %>">

    Product.create :title => 'Пепперони',
      :description => 'Это пицца Пепперони',
      :price => 450,
      :size => 30,
      :is_spicy => false,
      :is_veg => false,
      :is_best_offer => true,
      :path_to_image => '/images/02.jpg'
      # Если нам нужно 2 картинки большую и маленькую для разных страниц, то лучше добавить в таблицу еще одну колонку например тут :path_to_big_image, это будет лучше чем уменьшать большие картинки на странице, тк это уменьшит нагрузку на станицу и не будет замедлять ее работу
  end
end

# 3. Запускаем миграцию
rake db:migrate
# В фаиле schema.rb изменяется только номер version: 2023_06_13_060331

# 4. Дальнейшее заполнение основного фаила
get '/' do
	@products = Product.all
	erb :pizzashop_index
end


puts
puts '                              Форма со скрытым полем(использование JS)'

# На примере Pizzashop - форма для отправки заказов

# Модель для клиентов(и выполняем для него миграцию естественно)
class Client < ActiveRecord::Base
end

# Выделим "product_1=4,product_2=7,product_3=4," разбивку в метод(В Рэилс это называется хэлпер):
# Это не эффективный способ, лучше использовать json (позволяет поддерживать формат данных любой сложности).
def parse_orders_input(orders_input)
  #"product_1=4,product_2=7,product_3=4," => [["1", "4"], ["2", "7"], ["3", "4"]]
  orders_input.split(',').map{|prod| prod.split('=')}.map{|a| [a[0][-1], a[1]]}
end

# Тот случай когда только пост-обработчик. Тк для приема списка заказов пользователь только нажимает кнопку на главной странице, а данные берутся из локалсторэдж.
post '/cart' do
  @c = Client.new

	@order_code = params[:orders] # "product_1=4,product_2=7,product_3=4,"

  # Если пустой локаосторедж
  if @order_code.size == 0
		return erb "Cart is empty"
	end

	order_list = parse_orders_input(params[:orders])
	# => {obj1 => 4, ...} тоесть хэш где ключ сущность а значение число заказов на нее
	@order_list = order_list.map{|k, v| [Product.find(k.to_i), v.to_i]}.to_h

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
# 6. Нет тестов (в рейлс для всего существуют тесты)



















#
