puts '                                  ActiveRecord(на примере Sinatra)'

# ActiveRecord - это специальный гем для Ruby, который делает работу с БД более удобной и быстрой

# https://guides.rubyonrails.org/active_record_querying.html   -   справка по активрекорд(Active Record Query Interface — Ruby on Rails Guides)


puts
puts '                                       Gemfile и Gemfile.lock'

# Gemfile для приложений Синатры с ActiveRecord
source "https://rubygems.org"

gem 'sinatra', '~> 3.0'
gem 'sinatra-reloader', '~> 1.0'
gem 'sinatra-contrib', '~> 3.0'
# этот гем содержит sinatra-reloader(на самом деле это тоже разработческий гем и соотв можно поместить в group :development и его тоже)
gem "sqlite3"
gem "activerecord"
gem "sinatra-activerecord"
gem "rake"

group :development do # означает, что когда мы зальем приложение на хостинг, будет понятно что этот гем нужен исключительно для разработки, а не для работы приложения, поэтому в продакшен режиме он будет пропущен
  gem "tux"
end
# bundle install  - установка(из активной директории в которой лежит Gemfile)(может немного тупить)

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

# 3. Создадим модель - класс который будет представлять нашу сущность(entity). Модель/сущность описывает наши события - то с чем мы работаем(примеры сущностей: клиент, парикмахер, пост в блоге, комментарий итд). Класс сущности называется в единственном числе, тк объекты класса сущности будут содержать иформацию об одном экземпляре сущности(тут о конкретном клиенте) те о том что будет находится в одной строке БД.
class Client < ActiveRecord::Base # тут создаем сущность клиент: создаем класс который будет наследовать у ActiveRecord::Base
  # все больше ничего писать не надо, класс унаследовал все необходимые методы для работы с БД из класса Base модуля ActiveRecord, те произошла настройка ActiveRecord для нашей сущности
end


puts
puts '                                          rake, Rakefile, миграции'

# При помощи rake мы будем создавать таблицы(и их миграции) с нашими сущностями и управлять ими.

# Миграция - это очередная версия нашей базы данных. По аналогии с Git где существуют версии всего приложения +- тоже существует и для БД. У нас будут существовать различные версии наших БД и они будут вместе с кодом переходить из одной версии в другую, как раз при помощи механизма миграций

# Rakefile(rakefile, rakefile.rb, Rakefile.rb) - произошёл от СИшного Makefile(заменили M на R - мэйкфаил руби). В этот фаил прописываются определенные команды, которые мы можем исполнить

# нужно создать Rakefile в основном каталоге приложения

# В Rakefile мы записываем:
require "./app"   #=> подключаем основной фаил приложения, тут app.rb
require "sinatra/activerecord/rake"  #=> подключаем ActiveRecord с командами rake для Синатры

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

# 2. Заполняем app.rb и создаем модель/сущность как выше

# 3. Создаем фаил миграции. Вводим в консоли:
rake db:create_migration NAME=create_clients #(пишем маленькими буквами без пробелов; clients - название таблицы)
#=> db/migrate/20230523033236_create_clients.rb  # У нас в приложении создаются данные каталоги с данным rb фаилом
# 20230523033236 - дата и время создания фаила(специально чтоб миграции с одинаковыми именами отличались)
# Содержание фаила 20230523033236_create_clients.rb (заолняется автоматически):
class CreateClients < ActiveRecord::Migration[7.0]
  # CreateClients - класс нашей миграции унаследовавший методы из ActiveRecord::Migration[7.0]
  def change # метод созданный ActiveRecord, для того чтобы мы в нем создали миграцию (раньше вместо него в миграциях было 2 метода: up и down)
  end
end

# 4. Заполняем тело метода change(создаем макет таблицы):
class CreateClients < ActiveRecord::Migration[7.0]
  def change
    # аналог: db.execute 'CREATE TABLE IF NOT EXISTS "Users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "username" TEXT, "phone" TEXT, "datestamp" TEXT, "barber" TEXT, "color" TEXT)'
    create_table :clients do |t| # Метод create_table принимает в виде символа параметр с названием таблицы(название таблицы обязательно во множественном числе) присваивает в переменную t и далее лямбду в которой му задаем столбцы

      # столбец id INTEGER PRIMARY KEY AUTOINCREMENT будет создан автоматически

      t.text :name  # в таблице clients будет создан столбец name с типом TEXT
      t.text :phone
      t.text :datestamp
      t.text :barber
      t.text :color

      # типы столбцов в ActiveRecord:
      # text -> TEXT
      # string -> VARCHAR(255)
      # ...

      t.timestamps # создаст 2 дополнительных столбца created_at и updated_at - дата создания и обновления сущности, заполняются автоматически при добавлении или изменении сущности
    end
  end
end

# 5. Запускаем миграцию
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

# 2. Some.new - Создает объект только в памяти и чтобы его сохранить в БД нужно выполнить еще метод save:
b = Barber.new
b.save


puts
puts '                                                   tux'

# tux - это утилита и консоль для ActiveRecord, которая позволяет убравлять БД при помощи синтаксиса Руби

# gem install tux - устанавливает утилиту tux

# В приложении(Синатра) в основной директории есть фаил config.ru. Этот фаил нужен для утилиты/гема tux. При развертывании/deploy/deployment/залив на хостинг приложения этот фаил будет учитываться хостингом. Фаил содержит команды:
require './app'
run Sinatra::Application
# так же он запускает Руби чтобы он работал в tux, соотв мы можем его использовать для методов для модели


# tux (в консоли) - вход в текстовое меню утилиты tux (чем-то похоже на меню для sqlite3)
# exit (в консоли внутри утилиты) - выйти из текстового меню tux

# Команды в консоли Руби внутри утилиты(а так же в app и представлениях):
Client.all #=> Список всех сущностей в БД в таблице clients в виде объекта класса ActiveRecord::Relation содержащего в виде массива список объектов Client (SELECT "clients".* FROM "clients") (если не создана(или нет рэйкфаила??) выдаст ошибку)
Barber.count #=> 4 - Количество сущностей Barber в таблице barbers(SELECT COUNT(*) FROM "barbers")
Barber.create :name => 'Vasya' #=> заполняем таблицу новой сущностью при помощи create (INSERT INTO "barbers" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Vasya"], ["created_at", "2023-05-26 03:36:34.271601"], ["updated_at", "2023-05-26 03:36:34.271601"]])
b = Barber.new :name => 'Petya' #=> #<Barber id: nil, name: "Petya", created_at: nil, updated_at: nil>. создаем объект в памяти, если больше ничего не делать то он никуда не сохранится, если выйти из tux то объект исчезнет
b.new_record? #=> true  # проверяет новая ли запись в переменной b(не сохранена в БД)
b.save #=> по умолчанию проводит валидацию и вносит(создает или заменяет) Barber.new в таблицу (INSERT INTO "barbers" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Petya"], ["created_at", "2023-05-26 03:49:05.241644"], ["updated_at", "2023-05-26 03:49:05.241644"]])

# -- find - получить объект, соответствующий указанному первичному ключу
# SELECT * FROM customers WHERE (customers.id = 10) LIMIT 1
Customer.find(10) #=> #<Customer id: 10, first_name: "Ryan">
# вызовет ActiveRecord::RecordNotFound исключение, если соответствующая запись не будет найдена
# -- find для запроса нескольких объектов. Вызовите метод и передайте массив первичных ключей. Возврат будет массивом
# SELECT * FROM customers WHERE (customers.id IN (1,10))
Customer.find([1, 10]) #=> [#<Customer id: 1, first_name: "Lifo">, #<Customer id: 10, first_name: "Ryan">]
Customer.find(1, 10) # альтернатива
# Метод find вызовет исключение, если для всех предоставленных первичных ключей ActiveRecord::RecordNotFoundне будет найдена совпадающая запись



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


# примеры:
get '/' do
  @barbers = Barber.all # получаем в переменную всю таблицу barbers(SELECT * FROM barbers) как массив объектов

  # Сортировка при помощи метода order
  @barbers = Barber.order "created_at DESC" # получаем в переменную всю таблицу barbers(SELECT * FROM barbers ORDER BY created_at DESC) отсортированную по полю created_at и DESK переданные параметром в виде строки через пробел.

	erb :hq_barbershop_index
end


puts
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
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

  # Записываем новые данные в БД(Создаем новую сущность клиента и вводим данные в БД через параметр-хэш, где значения ключей это названия столбцов в фаиле миграции)
  Client.create(name: @username, phone: @phone, datestamp: @datetime, barber: @barber, color: @color)

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@color}"
end

# 2. Сохранение через Client.new в столбик(тоже ламерский способ)
post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

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
	erb :hq_barbershop_visit_true
end

post '/visit' do
  # Чтобы данный способ работал нужно изменить значения атрибутов name в виде hq_barbershop_visit_true
  c = Client.new params[:client] # Вместо client можно написать что угодно(главное в виде написать тоже самое название  client[имя_столбца]). В итоге мы получаем хэш со всеми значениями полей обозначенными названиями колонок БД для них.
  # К нам на сервер так и передается например 'client[name]' потом уже обрабатывается и получается хэш(в классе Client ??)
  c.save

	erb :hq_barbershop_visit_true
end


puts
puts '                                       Валидация и метод validates'

# https://guides.rubyonrails.org/active_record_validations.html  -   Active Record Validations — Ruby on Rails Guides

# Метод save по умолчанию проводит и валидацию, если всё правильно, то возвращает true иначе false.

# Хоть валидация и выполняется автоматически, но нужно ее настроить в основном фаиле app.rb в модели к которой относятся данные при помощи метода validates. Настройки могут позволить проводить валидацию по разлмчным параметрам: длинна строки, значение строки итд.

class Client < ActiveRecord::Base
  validates :name, presence: true  # 1й параметр это название столбца для проверки, 2й параметр это хэш с условиями проверки. В данном случае условие проверки presence: true означает, что значение для столбца name не должно быть пустым
  validates :phone, presence: true, length: { minimum: 6 }  # можжно делать по нескольким типам проверки сразу
  validates :datestamp, presence: true
  validates :color, presence: true

  #                    Некоторые другие популярные методы проверки:

  #     1. length - проверяем по допустимой длинне
  # validates :name, length: { minimum: 2 }             # minimum - длинна не менее чем
  # validates :bio, length: { maximum: 500 }            # maximum - длинна не более чем(можно указать одновременно с предыдущим)
  # validates :password, length: { in: 6..20 }          # in - допустимая длинна находится в интервале
  # validates :registration_number, length: { is: 6 }   # is - точное указание длинны

  #     2. inclusion - проверяем по наличию необходимой подстроки(имэил лучше всего проверять по наличию '@')
  # validates :size, inclusion: { in: %w(small medium large), message: "%{value} is not a valid size" }

  # numericality: true - проверка, введены ли числа

end
# если больше ничего не добавлять для валидации в программе, то будет просто не сохранять в БД, если проверка не пройдена, те метод вернул false и чтобы ошибка както отображалась, нужно это дополнительно проверить.

# Если мы проверим незаполненного клиента в tux то:
c = Client.new     #=> #<Client id: nil, name: nil, phone: nil, datestamp: nil, barber: nil, color: nil, created_at: nil, updated_at: nil>
c.valid?           #=> false  - это метод валидации для tux
c.errors.count     #=> 4 - выводит число незаполненных полей(ошибок)
c.errors.messages  #=> {:name=>["can't be blank"], :phone=>["can't be blank"], :datestamp=>["can't be blank"], :color=>["can't be blank"]} - выводит сообщения об ошибках, мы можем использовать ее для вывода
# Эти свойства мы так же можем использовать в обработчиках и методах основной программы.

class Barber < ActiveRecord::Base
end

before do
	@barbers = Barber.all
end

# Валидачия и вывод сообщения об ошибке
get '/visit' do
  @c = Client.new # создаем пустой объект для того чтобы методы названий столбцов не обращались к nil в виде(знач value) и не возникала ошибка.

	erb :hq_barbershop_visit_true
end

post '/visit' do
	@c = Client.new params[:client] # делаем переменную глобальной, чтобы отображалась в представлении

  if @c.save # валидация проводится по условиям из модели, вносит или не вносит Client.new в базу и возвращает true или false
		erb "<p>Thank you!</p>"
	else
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
  @barber = Barber.find(params[:id]) # find - метод актив рекорд(получает объект по праймари кей те id). params[:id] - как и раньше принимает значение из адреса обработчика
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



















#
