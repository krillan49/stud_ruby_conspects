puts '                                               generate'

# Не обязательно пользоваться генераторами и можно все создавать в ручную

# generate - команда для запуска генераторов с различными параметрами

# > rails generate генератор параметры_генератора
# > rails g генератор параметры_генератора

# > rails g     # показывает список всех генераторов которые есть у нас в системе

# Виды генераторов(бывают как от самого Рэилс так и от различных гемов):
# controller - для генерации контроллеров с маршрутами и предсталениями для них
# model      - для генерации моделей и миграций
# migration  - генератор миграции без модели
# scaffold   - генератор одновременно для модели, контроллера, экшенов, маршрутов, представлений, тестов по REST resourses.
# ...


puts
puts '                                                  MVC'

# MVC(Model, View, Controller) - архитектура/паттерн, разделяющаяя приложение на 3 части, в каждой из которых высокая связанность, при слабой связанности между самими частями
# Model      - бизнес логика/функционал, например работа с базами данных
# View       - виды представления, то что видит пользователь
# Controller - тонкая управляющая прослойка между Model и View, осуществляет их взимодействие


# В случае с Рэилс запрос браузера сначало попадает в Rails router(его конфигурация находится в /config/routes.rb), а уже оттуда в соотв с прописанными там машрутами передается в контроллер, контроллер делает запрос к модели, модель обращается в БД, передает данные в виде сущности контроллеру, он передает их в представление и затем возвращает html сгенерированной страницы в браузер.

#   Контроллер - выполняет обработку URL запросов от браузера. В зависимости от типа и URL запроса, возвращает браузеру определенный HTML шаблон. Перед открытием шаблона контроллер может связаться с моделью и получить значения из БД, которые будут переданы в шаблон;
#   Вид - выполняет роль обычного HTML шаблона, который будет показан пользователю в качестве страницы веб сайта. Эти шаблоны вызываются при помощи контроллеров в зависимости от URL адреса запроса;
#   Модель - отвечает за функциональную часть в приложении. В моделях происходит связь с базой данных, работа с API итд. Получив какие-либо значения из базы данных их можно передать обратно в контроллер и далее они будут переданы во view.


puts
puts '                                    Модели и миграции(ActiveRecord)'

# Миграции - это некий програмный код, с помощью которого мы можем описать, какие таблицы в БД нужно создать, модифицировать итд. Миграции располагаются по меткам времени(в названии 20230701043625_cr...), те можно четко отследить что и в какой последовательности делали. Когда наш проект переносится на другой носитель, то мы можем при помощи одной команды применить все миграции и таким образом наша БД оказывается сразу в нужном нам состоянии, со всеми нужными таблицами, связями итд

# config/database.yml  -  в этом фаиле содержится инфа о том какие БД присутствуют в проекте(подробнее в этом фаиле на примере проекта AskIt с курса Круковского)

# По умолчанию Rails настроен на работу с СУБД sqlite3

# Создание БД через командную строку(в Rails 7 уже есть по умолчанию development.sqlite3 и создаст только test.sqlite3):
# > rails db:create RAILS_ENV=development       -  для виндоус
# > RAILS_ENV=development rails db:create       -  для никс-систем
# Если используется другая СУБД например Постгресс, перед выполнением команды она должна быть запущена

# Модели в Рэилс, хранятся в отдельных фаилах в каталоге app/models/

# Модели можно создавать при помощи генератора или вручную


# А. > rails g model Article title:string text:text    -   Создание модели и миграции, таблицы, БД(если еще не создана):
# rails g                - команда создания чегото;
# model                  - генератор модели, значит что создаем модель;
# Article                - название модели(тот класс что отвечает за сущности, те в единственном числе);
# title:string text:text - свойства класса модели, те столбцы таблицы и типы данных для них(при генерации модели :string тк этот тип данных будет и по умолчанию);
# После запуска при помощи active_record будет автоматически созданы и описаны в выводе:
# 1. app/models/article.rb  -  фаил модели(В Синатре была в app.rb)
class Article < ApplicationRecord # (Article - единственное число)
  # Модели наследуются от главной модели ApplicationRecord а она от ActiveRecord::Base (для методов AR ?) содержит has_many, validates итд
end
# 2. db/migrate/20230701043625_create_articles.rb (articles - множественное число) - миграция(с уже заполненным методом change)
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|  # таблица создается в БД которая указана в конфигурации config/database.yml
      t.string :title
      t.text :text

      t.timestamps  # создан автоматически без необходимости указания в команде генерации модели
    end
  end
end
# 3. юнит тесты.

# Б. > rake db:migrate     -   далее выполняем миграцию.
#    > rails db:migrate    -   или так, алиасы ??.

# В. Отмена миграций, если сделали чтото не так
# > rails db:rollback         - отменит все сделанные миграции(именно выполнение, те удалятся из схемы, но фаилы миграций останутся, делает дроп тайбл, тоесть данные теряются)
# > rails db:rollback STEP=1  - отменит столько последних миграций какой указан параметр после STEP=


# Примечание. Почти всегда таблица это множественное число от модели, но иногда Рэилс делает нестандартно, например для модели Person создаст таблицу people а не persons
# В книге Rails. Гибкая разработка веб-приложений (Руби, Томас, Хэнссон) можно прочитать про соглашения об именах.


puts
puts '                                     Rails console(работа с моделями)'

# Консоль Рэилс (похожа на tux для Синатры). Можно писать в ней любой рубикод

# > rails console  -  вход в консоль
# > rails c        -  вход в консоль
# exit             -  выход

# Примеры работы:
Contact.all #=> SELECT "contacts".* FROM "contacts"  => []
Article.find(6) #=> SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 6], ["LIMIT", 1]]
Contact.attribute_names #=> ["id", "email", "message", "created_at", "updated_at"] # узнать какие свойства(поля) у сущности
Comment.last


puts
puts '                                              Контроллеры'

# Controller - это специальный класс, который часто взамодействует с к какой-либо моделью, он находится в своем фаиле и отвечает за обработку запросов с URL адреса и возврат представлений браузеру.

# Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers. Контроллеры, которые разнесены по разным фаилам содержат экшены.
# Экшен - это метод отвечающий за обработчик(get, post итд) какого-либо URL

# Контроллеры наследуются от ApplicationController, а ApplicationController наследуется от ActionController::Base
# ApplicationController(для наших кастомных методов ?) мы напишем метод и его унаследуют все наши контроллеры
# ActionController::Base - (для методов pзэилс ?) содержит методы params, respond_to итд

# Контроллер(а так же маршруты, экшены, виды итд для него) можно полностью создать в ручную, а можно при помощи специальных команд в терминале.
# Название фаила контроллера somename_controller.rb где somename обычно в множественном числе, например pages


puts
puts '                                       Генерация контроллера'

# > rails generate controller home index  -  команда создания контроллера, где:
# rails generate - команда создания чегото;
# controller     - генератор контроллера, говорит о том что мы будем создавать контроллер;
# home           - название контроллера;
# index          - action(название метода/действия).

# В итоге было сгенерировано(В отладочной инфе пишет все что добавилось):
# 1. app/controllers/home_controller.rb - фаил в котором находится код контроллера:
class HomeController < ApplicationController # контроллер это класс наследующий от главного контроллера
  def index # а экшен/действие это метод в этом классе(отвечающий за обработку запросов)
    # по умолчанию get 'home/index'
    # по умолчанию возвращает(рэндерит) index.html.erb
    # по умолчанию всегда возвращает представление с именем экшена из поддиректории с именем контроллера
  end
end
# 2. маршрут home/index в config/routes.rb
# 3. поддиректорию home и фаил index.html.erb в ней(app/views/home/index.html.erb)
# 4. тесты и хэлперы


puts
puts '                                Пошаговое создание контроллера(resourses)'

# Сделаем контроллер для работы с сущностями модели Article пошагово

# 1. http://localhost:3000/articles/new - выпадет ошибка Routing Error. Это происходит потому что у нас нет контроллера articles и соотв такого маршрута. Создадим контроллер(без указания экшенов):
# > rails g controller articles  (можно не использовать генератор вообще и создать в ручную и фаил и сам класс)
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # Создался пустым, тк мы не задавали 2й параметр(new)
end

# 2. http://localhost:3000/articles/new - выпадет ошибка Unknown action The action 'new' could not be found for ArticlesController. Тк как у нас не было метода экшена в классе контроллера, далее добавим его вручную:
class ArticlesController < ApplicationController
  def new
  end
end


puts
puts '                                   Маршруты(routes.rb). rails routes'

# http://rusrails.ru/rails-routing             -  Rusrails: Роутинг в Rails
# https://guides.rubyonrails.org/routing.html

# Маршрут - это то что пишется в адресной строке браузера

# config/routes.rb - тут мы прописываем и изменяем маршруты, которые будут использоваться в нашем приложении. Когда приходит запрос с методом и маршрутом, то Рэилс смотрит в routes.rb, в какой контроллер и экшен его передавать для обработки

# Пропишем маршруты(закрепим обработчики URLов за опред экшенами). Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  #                                        Корневой маршрут

  # home#index обычно создаётся для главной страницы, поэтому можно поменять 'home/index'(создан контроллером по умочанию) на корневой маршрут:
  get '/' => 'home#index'  # определяем маршрут вручную(хардкод). Направили обработчик URL get '/' в экшен index контроллера home Теперь экшен index контроллера home будет обрабатывать GET-запрос если он придет с URL-адреса '/'
  get '/', to: 'home#index' # альт синтаксис тому что выше
  # to: "home#index" - аргумент хэш
  # to: указывает на то какой экшен будет обрабытывать запрос

  root "home#index", as: 'some' # альтернатива get '/' при помощи хэлпера root
  # as: 'some'  - не обязательное переименование хэлпера для URL root_path(перестает работать) в some_path
  # (так же можно создавать хэлперы и для хардкод маршрутов вроде get '/' => 'home#index')
  root to: "home#index" # ?? хз в чем разница с тем что выше


  #                                resources - маршруты по паттерну REST

  # Маршруты для рпботы с моделью Article и контроллером ArticlesController
  resources :articles
  # ресурс != модель. Может быть ресурс без модели и модель, не использующаяся как ресурс.

  # Prefix       Verb    URI Pattern                  Controller#Action
  # -----------------------------------------------------------------------
  # articles     GET     /articles(.:format)          articles#index
  #              POST    /articles(.:format)          articles#create
  # new_article  GET     /articles/new(.:format)      articles#new
  # edit_article GET     /articles/:id/edit(.:format) articles#edit
  # article      GET     /articles/:id(.:format)      articles#show
  #              PATCH   /articles/:id(.:format)      articles#update
  #              PUT     /articles/:id(.:format)      articles#update
  #              DELETE  /articles/:id(.:format)      articles#destroy


  #                          Обычный подход без REST, определяли маршрут вручную

  # resources это не более чем синтаксический сахар. Нет никакой разницы между написаннным выше и такой конструкцией:
  get '/questions', to: 'questions#index'
  get '/questions/new', to: 'questions#new'
  post '/questions', to: 'questions#create'
  get '/questions/:id/edit', to: 'questions#edit'
  # ...
  # или такой:
  get "semester" => "semesters#show"
  get "semesters" => "semesters#index"
  get "edit_semester" => "semesters#edit"
  get "new_semester" => "semesters#new"
  patch "semesters" => "semesters#update"
  post "semesters" => "semesters#create"
  # ?? втф что за странные адреса-хэлперы ??
end
# Примечание: если мы прописываем несколько маршрутов URL для одного и тогоже экшена и контроллера, то он будет обрабатывать все эти маршруты

# > rails routes  -  эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут. Удобно смотреть к каким контроллерам что ведет, если забыл.
# (До версии Rails 6.1 необходимо использовать команду: rake routes вместо rails routes.)
# Так же можно смотреть маршруты в браузере введя несуществующий URL(например в еще одном окне чтоб смотреть), либо перейти по адресу /rails/info/routes


puts
puts '                           Контроллер и роутинг статических страниц(не по REST)'

# Статические страницы это те которые не изменяются динамически, те никаких some/id, а только some ?? и никакой динамической информации, те всегда отображаются одинаково ?? например просто передаются переменными из экшенов ??. Подходит например для страниц "О нас", "Контакты" итд

# Удобно создать отдельный контроллер для статических страниц
# > rails g controller pages

# Создаётся контроллер /app/controllers/pages_controller.rb, добавим экшены:
class PagesController < ApplicationController
  def terms
  end

  def about
  end
end

# Пропишем маршруты(тк удобнее получать их от корня, а не от /pages) в /config/routes.rb:
Rails.application.routes.draw do
  get 'terms' => 'pages#terms'
  get 'about' => 'pages#about', as: 'about'
  # as: 'about' - для статических тоже можно создать хэлперы юрлов, тут about_path
end

# Создадим представления /app/views/pages/terms.html.erb и /app/views/pages/about.html.erb


puts
puts '                      Полный цикл создания контроллера, маршрутов, модели, видов(resourse)'

# Сделаем страницу /contacts с формой для контактов. Чтобы на сервер и далее в БД передавались email и message из формы контактов.

# 1. > rails g controller contacts  -  Создаем новый контроллер без экшенов
# Создалось: app/controllers/contacts_controller.rb и app/views/contacts
class ContactsController < ApplicationController
  # Добавим в ContactsController экшены
  def new # получение страницы(форма с текстовыми полями) от сервера  - get (new по REST)
  end
  def create # отправка и обработка данных введенных пользователем на сервер - post (create по REST)
  end
end

# 2. Прописываем маршруты. Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  resource :contacts, only: [:new, :create] # resource(единственное число).
  # only: [:new, :create] (или only: %i[new create]) - хэш с параметрами, тут указывает на то, что нужны маршруты только для методов new и create, отстальние 4 нам тут не нужны.
end
# Теперь если прверить при помощи rails routes то появилось 2 новых строки а не 6
# new_contacts   GET    /contacts/new(.:format)    contacts#new
# contacts       POST   /contacts(.:format)        contacts#create

# 3. Создаем модель и миграцию и запускаем миграцию.
# > rails g model Contact email:string message:text  -  Создадим модель Contact c 2мя свойсвами(столбцами)
# AR создал миграцию: db/migrate/20230704072035_create_contacts.rb
class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
# AR создал модель: app/models/contact.rb
class Contact < ApplicationRecord
end
# rake db:migrate  -  запускаем миграцию и создаем таблицу в БД

# 4. Создадим представление contacts/new.html.erb и заполняем(формой)
# Добавим предствление /app/views/contacts/create.html.erb


puts
puts '                                  Пример изменения стандартных маршрутов'

# Сейчас при GET-запросе на URL /contacts выпадает Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик(create). Сделаем так, чтобы GET '/contacts' у нас обрабатывался в экшене new, соотв возвращался вид new.html.erb с формой.(У resource по этому запросу по умолчнию show.)

# /config/routes.rb:
Rails.application.routes.draw do
  # Способ 1(хардкод):
  get 'contacts' => 'contacts#new'  # добавим обработку запроса get 'contacts' в экшен new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
  # Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю строку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

  # Способ 2(Лучше тк меняет имя хэлпера и не будет ошибок, например с приемочными тестами):
  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути { :new => '' } (По умолчанию был {:new => '/new'} ). А базовый путь для контроллера contacts это как раз /contacts
end















#
