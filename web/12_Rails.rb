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
puts '                                               Контроллеры'

# Controller - это специальный класс, который часто относится к какой-либо сущности, он находится в своем фаиле и отвечает за обработку запросов с URL адреса(и возвращаемыми видами для него).
# Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers
# Контроллеры, которые разнесены по разным фаилам содержат экшены.
# Экшен - это метод отвечающий за обработчик(get, post итд) какого-либо URL

# Контроллеры наследуются от ApplicationController, а ApplicationController наследуется от ActionController::Base
# ApplicationController(для наших кастомных методов ?) мы напишем метод и его унаследуют все наши контроллеры
# ActionController::Base - (для методов pзэилс ?) содержит методы params, respond_to итд

# Контроллер(а так же маршруты, экшены, виды итд для него) можно полностью создать в ручную, а можно при помощи специальных команд в терминале.
# Название фаила контроллера somename_controller.rb гду somename обычно в множественном числе, например pages

# > rails generate controller home index  -  команда создания контроллера, где:
#     rails generate - команда создания чегото;
#     controller - генератор контроллера, говорит о том что мы будем создавать контроллер;
#     home - название контроллера ;
#     index - action(название метода/действия).
# Мы создали(В отладочной инфе пишет все что добавилось):
# 1. фаил app/controllers/home_controller.rb В нем находится код:
class HomeController < ApplicationController # контроллер это класс наследующий от главного контроллера
  def index # а экшен/действие это метод в этом классе(отвечающий за обработку запросов)
    # по умолчанию get 'home/index'
    # по умолчанию возвращает(рэндерит) index.html.erb
  end
  # Каждый экшен обрабатывает определенный HTML шаблон с таким же названием файла, что и название метода.
end
# 2. маршрут home/index
# 3. поддиректорию home и фаил index.html.erb в ней(app/views/home/index.html.erb)
# 4. тесты и хэлперы

# http://localhost:3000/home/index  -  теперь это представление можно открыть в браузере


# В консоли выходит инфа о запросе и том какие представления рэндерятся:
# Started GET "/" for ::1 at 2023-10-16 12:19:23 +0300
# 12:19:23 web.1  | Processing by PagesController#index as HTML
# 12:19:23 web.1  |   Rendering layout layouts/application.html.erb
# 12:19:23 web.1  |   Rendering pages/index.html.erb within layouts/application
# 12:19:23 web.1  |   Rendered pages/index.html.erb within layouts/application (Duration: 20.8ms | Allocations: 159)
# 12:19:23 web.1  |   Rendered layout layouts/application.html.erb (Duration: 35.5ms | Allocations: 3676)
# 12:19:23 web.1  | Completed 200 OK in 51ms (Views: 47.1ms | ActiveRecord: 0.0ms | Allocations: 4556)


puts
puts '                          Маршруты(routes.rb). Корневой маршрут. Команда rails routes.'

# Маршрут - это то что пишется в адресной строке браузера

# https://guides.rubyonrails.org/routing.html

# config/routes.rb - тут мы прописываем и изменяем маршруты, которые будут использоваться в нашем приложении.

# Когда приходит запрос с методом и маршрутом, то Рэилс смотрит в routes.rb, в какой контроллер и экшен его передавать для обработки

# Пропишем маршрут(закрепим обработчики URLов за опред экшенами). Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  # Обычно home#index создаётся для главной страницы сайта, поэтому можно поменять корневой маршрут и прописать в нем вместо get 'home/index'(который был по умочанию):
  get '/' => 'home#index'  # определяем маршрут вручную(хардкод). Направили обработчик URL get '/' в экшен index контроллера home
  # Теперь экшен index контроллера home будет обрабатывать GET-запрос если от придет с URL-адреса '/'

  # альт синтаксис тому что выше ??
  get '/', to: 'home#index' # to: "home#index" - аргумент хэш
  # to: указывает на то какой экшен будет обрабытывать запрос


  root "home#index", as: 'some' # альтернатива при помощи хэлпера root
  # as: 'some'  - не обязательное переименование(старый перестает работать) хэлпера root_path в some_path
  # Так же можно сосдавать хэлперы и для хардкод маршрутов вроде get '/' => 'home#index'

  root to: "home#index"
end
# Примечание: если мы прописываем несколько маршрутов URL для одного и тогоже экшена и контроллера, то он будет обрабатывать все эти маршруты


# > rails routes  -  эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут. Удобно смотреть к каким контроллерам что ведет, если забыл.
# (До версии Rails 6.1 необходимо использовать команду: rake routes вместо rails routes.)

# Так же можно смотреть маршруты в браузере введя несуществующий URL(например в еще одном окне чтоб смотреть), либо перейти по адресу /rails/info/routes


puts
puts '                              params с гет-параметрами(из строки GET-запрса)'

# http://localhost:3000/?name=kroker    -   если ввести это, те сослать гет запрос на нашу корневую страницу с гет-параметрами ?name=kroker, то params сможет получить эти данные по ключу соотв name.
# (Подробности запроса описываются в консоли, где запущен сервер.)

# Обработаем параметры в нашем контроллере:
class HomeController < ApplicationController
  def index
    @name = params[:name]
  end
end
# далее вставим @name в вид home/index.html.erb
# Теперь если ввести данные в URL через слэш после адреса, то выведет значение что после =

# В консоли отображается обработка параметров:
# 12:31:50 web.1  | Started GET "/?name=kroker" for ::1 at 2023-10-16 12:31:50 +0300
# 12:31:50 web.1  | Processing by PagesController#index as HTML
# 12:31:50 web.1  |   Parameters: {"name"=>"kroker"}



puts
puts '                                    Модели и миграции(ActiveRecord)'

# Миграции - это некий програмный код, с помощью которого мы можем описать, какие таблицы в БД нужно создать, модифицировать итд. Миграции располагаются по меткам времени(в названии 20230701043625_cr...), те можно четко отследить что и в какой последовательности делать. Когда наш проект переносится на другой носитель, то мы можем при помощи одной команды применить все миграции и таким образом наша БД оказывается сразу в нужном нам состоянии, со всеми нужными таблицами, связями итд

# config/database.yml  -  в этом фаиле содержится инфа о том какие БД присудствуют в проекте(подробнее в этом фаиле на примере проекта AskIt с курса Круковского)

# Создание БД через командную строку(в Rails 7 development.sqlite3 и создаст только test.sqlite3):
# > rails db:create RAILS_ENV=development       -  для виндоус
# > RAILS_ENV=development rails db:create       -  для никс-систем
# Если используется другая СУБД например Постгресс, перед выполнением команды она должна быть запущена


# По умолчанию Rails настроен на работу с СУБД sqlite3

# Создание модели(В Синатре была в app.rb, в Рэилс в каталоге app) и миграции, таблицы, БД(если еще не создана):

# А. > rails g model Article title:string text:text    -   Создадим модель и миграцию:
#   rails g(generate) - команда создания чегото;
#   model - генератор модели, значит что создаем модель;
#   Article - название модели(тот класс что отвечает за сущности, те в единственном числе);
#   title:string text:text - свойства класса модели, те столбцы таблицы и типы данных для них;
# После запуска при помощи active_record будет автоматически созданы и описаны в выводе:
# 1. фаил модели(В Синатре была в app.rb)  app/models/article.rb
class Article < ApplicationRecord # (Article - единственное число)
  # Модели наследуются от главной модели ApplicationRecord а она от ActiveRecord::Base (для методов AR ?) содержит has_many, validates итд
end
# 2. миграция(с уже заполненным методом change)   db/migrate/20230701043625_create_articles.rb (articles - множественное число)
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

# Б. rake db:migrate    -   далее выполняем миграцию.
# > rails db:migrate    -   или так, алиасы ??.
# База данных находится/создается в каталоге db/development.sqlite3

# В. Отмена миграций, если сделали чтото не так
# > rails db:rollback         - отменит все сделанные миграции(именно выполнение, те удалятся из схемы, но фаилы миграций останутся, делает дроп тайбл, тоесть данные теряются)
# > rails db:rollback STEP=1  - отменит столько последних миграций какой указан параметр


# Примечание. Почти всегда таблица это множественное число от модели, но иногда Рэилс делает нестандартно, например для модели Person создаст таблицу people а не persons
# В книге Rails. Гибкая разработка веб-приложений (Руби, Томас, Хэнссон) можно прочитать про соглашения об именах.


puts
puts '                                     Rails console(работа с моделями)'

# Консоль Рэилс похожа на tux что мы использовали в Синатре, работает точно так же. Можно писать в ней любой рубикод

# > rails console  -  вход в консоль
# > rails c        -  вход в консоль
# exit             -  выход

# Примеры работы:
Contact.all #=> SELECT "contacts".* FROM "contacts"  => []
Article.find(6) #=> SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 6], ["LIMIT", 1]]
Contact.attribute_names #=> ["id", "email", "message", "created_at", "updated_at"] # узнать какие свойства(поля) у сущности


puts
puts '                                  Пошаговое создание контроллера(resourses)'

# Сделаем контроллер для работы с сущностями модели Article пошагово, а не просто одной командой(rails g controller articles new)

# 1. http://localhost:3000/articles/new - выпадет ошибка Routing Error. Это происходит потому что у нас нет контроллера articles и соотв такого маршрута. Создадим контроллер(без указания экшенов):
# > rails g controller articles
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # Создался пустым, тк мы не задавали 2й параметр(new)
end

# 2. http://localhost:3000/articles/new - выпадет ошибка Unknown action The action 'new' could not be found for ArticlesController. Тк как у нас не было метода экшена в классе контроллера, далее добавим его вручную:
class ArticlesController < ApplicationController
  def new
  end
end

# 3. Пропишем маршруты в /config/routes.rb
Rails.application.routes.draw do
  get '/' => 'home#index'  # Обычный подход без REST, определяли маршрут вручную

  resources :articles # REST подход(назначает маршруты по паттерну REST)
  # Строго говоря, ресурс != модель. У вас может быть ресурс без модели и модель, не использующаяся как ресурс.

  # resources это не более чем синтаксический сахар. Нет никакой разницы между написаннным выше и такой конструкцией:
  get "semester" => "semesters#show"
  get "semesters" => "semesters#index"
  get "edit_semester" => "semesters#edit"
  get "new_semester" => "semesters#new"
  patch "semesters" => "semesters#update"
  post "semesters" => "semesters#create"
  # ?? втф что за транные адреса-хэлперы ??
end
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

# 4. http://localhost:3000/articles/new - выпадет ошибка ArticlesController#new is missing a template for request formats: text/html. Ошибка говорит о том что отсутствует шаблон(представление)
# Создадим вручную файл app/views/articles/new.html.erb


puts
puts '                                  Работа с представлениями. Форма в Рэилс'

# 1. Создаем форму в articles/new.html.erb

# 2. Добавим в app/controllers/articles_controller.rb экшен create для обработки данных отправленных формой из new.html.erb:
class ArticlesController < ApplicationController
  def new # get '/articles/new'
    # по умолчанию возвращает new.html.erb
  end
  def create # post '/articles'
    render plain: params[:article].inspect
    # render - метод для возврата данных из экшена без вида. Выводит по URL экшена create те post '/articles' ??;
    # plain: params[:article].inspect - параметр функции render;
    # plain: - ключ хеша(обозначает что будет выведен просто текст);
    # params[:article].inspect - значение хеша.
    # В итоге выведет #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.

    render 'articles/create' # можно вывести представления по имени директори и фаила в каталоге views

    # по умолчанию возвращает(рэндерит) create.html.erb(render 'articles/create')
  end
end

# Страницу /articles пользователь не сможет открыть вручную, тк для нее сейчас есть только POST-обработчик, но нет GET(index)


puts
puts '                                    Пошаговое создание контроллера(resourse)'

# Сделаем страницу /contacts с формой для контактов. Чтобы на сервер и далее в БД передавались email и message из формы контактов.

# 1. > rails g controller contacts  -  Создаем новый контроллер без экшенов
# Создалось: app/controllers/contacts_controller.rb и app/views/contacts
class ContactsController < ApplicationController
end

# 2. Добавим в ContactsController экшены
class ContactsController < ApplicationController
  def new # получение страницы(форма с текстовыми полями) от сервера  - get (new по REST)
  end
  def create # отправка и обработка данных введенных пользователем на сервер - post (create по REST)
  end
end

# 3. Прописываем маршруты. Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  get '/' => 'home#index'
  resources :articles

  resource :contacts, only: [:new, :create] # resource(единственное число). Нам нужно только new и create, отстальние 4 нам тут не нужны.
end
# Теперь если прверить при помощи rails routes то появилось 2 новых строки а не 6
# new_contacts   GET    /contacts/new(.:format)    contacts#new
# contacts       POST   /contacts(.:format)        contacts#create

# 4. Создаем модель и миграцию и запускаем миграцию.
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

# 5. Создадим представление contacts/new.html.erb и заполняем(формой)
# Добавим предствление /app/views/contacts/create.html.erb


puts
puts '                             Запись в БД. Разрешение на использование атрибутов'

# Откроем /app/controllers/contacts_controller.rb и запишем код.
class ContactsController < ApplicationController
  def new
  end

  def create # принимает данные введенные пользователем в форму
    @contact = Contact.new(params[:contact])
    # Но если принимать параметры так, то при нажатии кнопки формы вылезет ошибка: ActiveModel::ForbiddenAttributesError in ContactsController#create. Аттрибуты params[:some] по умолчанию запрещены(связано с безопасностью) и их нужно разрешить, для этого используется специальный синтаксис:
    @contact = Contact.new(contact_params) # вместо params[:contact] вызываем наш разрешающий метод
    @contact.save
  end

  private

  def contact_params # название метода обычно такое(сущность_params), хотя можно любое
    params.require(:contact).permit(:email, :message)
    # require(:contact) - форма или хэш ??
    # permit(:email, :message) - содержит все столбцы
  end
end
# Теперь мы можем добавить запись в БД через форму /contacts/new


puts
puts '                            Реализация объекта params и разрешения параметров'

# params - объект(хэш хэшей) который по умолчанию присутсвует(переходит при наследовании из ApplicationController) в контроллере. Можно обратиться к нему из любого метода в контроллере. В нем хранятся все параметры которые передаются из браузера в приложение.

# params – это не просто хеш, а объект определенного класса, но по своему виду очень напоминает хеш

# https://api.rubyonrails.org/classes/ActionController/Parameters.html -  реализация params в ActionController

params = ActionController::Parameters.new({
  person: {
    name: "Francesco",
    age:  22,
    role: "admin"
  }
})

params = ActionController::Parameters.new
params.permitted? # => false  # проверяем разрешен или нет только что созданный params. Тоже самое автоматически проверяется методами(методами сущности а не контроллера) изменяющими БД: save, create, updste, destroy

# require(:contact) - требует наличия параметров.
ActionController::Parameters.new(person: { name: "Francesco" }).require(:person) #=> #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>
# require – метод, который получает значение хэша по ключу, где ключом в данном случае является наш ресурс, указанный в форме. Если такого ключа нет, то Rails выбросит ошибку

# permit(:email, :message) (изменяет значение метода permitted? на true)
params = ActionController::Parameters.new(user: { name: "Francesco", age: 22, role: "admin" })
permitted = params.require(:user).permit(:name, :age)
permitted.permitted?      # => true
permitted.has_key?(:name) # => true
permitted.has_key?(:age)  # => true
permitted.has_key?(:role) # => false
# permit – метод, который определяет разрешенные параметры в нашем ресурсе для передачи их значений в контроллер. Мы указываем только то, что хотим получить!

# Тоесть тут мы разрешили только параметры name и age для сущности user. И теперь если хакер захочет админские права и нам передаст в запросе чтото вроде:
# user[name]=Francesco&user[age]=22&user[role]=admin
# то механизм разрешений отсечет все лишнее и пропустит только:
# user[name]=Francesco&user[age]=22

# Browser ===> Server ===> Controller ===> ActiveRecord ===> Database
#                                              ||
#                                              ===> тут идет наша защита(методы .new, .create итд)


puts
puts '                                               Валидация'

# 1. Валидацию надо добавить в модель /app/models/contact.rb
class Contact < ApplicationRecord
  # Синтаксис тот же самый что и в Синатре, тк это тот же самый ActiveRecord
  validates :email, presence: true
  validates :message, presence: true
end

# 2. Исправим код в методе create в контроллере /app/controllers/contacts_controller.rb:
def create
  @contact = Contact.new(contact_params)
  if @contact.valid? # это можно не писать и тут сразу написать @contact.save
    @contact.save # содается сущность и строка в БД(создастся и без create.html.erb тк создает до возврата вида)
    # тут по умолчанию возвращает create.html.erb
  else
    # а если не валидно вернем нашу форму new.html.erb(но уже на URL /contacts) при помощи render
    render action: 'new'
    # render - метод для возврата данных из экшена, тк это возврат, то(в отличие от redirect_to) сохраняет данные из метода, например переменные
    # action: - значит что возвращаем экшен(тело метода и соотв вид new ??)
    # 'new' - имя экшена
  end
end

# 3. Теперь, если при заполнении формы будет ошибка валидаци, то форм билдер нам подскажет, автоматически обернув лэйбл неправильно заполненного поля и само поле в div-ы:
'<div class="field_with_errors"></div>'
# Оформление можно добавить любое через CSS в файле /app/assets/stylesheets/application.css
# Значения правильно заполненных полей вносит в value автоматически

# 4. Выведем список ошибок. Вывод будет таким ["Email can't be blank", "Message can't be blank"]
# Вариант 1(так без ошибок будет выведен пустой массив): В new.html.erb добавим код для сообщения об ошибках.
# В app/controllers/contacts_controller.rb нужно определить переменную:
def new
  @contact = Contact.new # пустая сущность
end
# Вариант 2: без пустой сущности записать в /app/views/contacts/new.html.erb


puts
puts '                                  Пример изменения стандартных маршрутов'

# Сейчас у нашего блога при ручном заходе(GET) на /contacts выпадает Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик(create). Сделаем так, чтобы GET '/contacts' у нас обрабатывался в экшене new, соотв возвращался вид new.html.erb с формой.(У resource по этому запросу по умолчнию show.)

# Откроем /config/routes.rb и добавим код:
Rails.application.routes.draw do
  # Способ 1(хардкод):
  get 'contacts' => 'contacts#new'  # добавим обработку запроса get 'contacts' в экшен new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
  # Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю строку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

  # Способ 2(Лучше тк меняет имя хэлпера и не будет ошибок, например с приемочными тестами):
  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути { :new => '' } (По умолчанию был {:new => '/new'} ). А базовый путь для контроллера contacts это как раз /contacts
end


puts
puts '                                         index(resourses)'

# Выведем все наши статьи

# Внесём изменения в /app/controllers/articles_controller.rb:
class ArticlesController < ApplicationController
  def new
  end

  # Заполним метод create для articles.
  def create
    @article = Article.new(article_params)
    if @article.save
      # по умолчанию возвращает create.html.erb
    else
      render action: 'new'
    end
  end
  # Создадим представление /app/views/articles/create.html.erb
  # Добавим ссылку в create.html.erb на все статьи '/articles'

  # Добавим экшен index. Список статей будет доступен по адресу /articles
  def index # get '/articles'
    @articles = Article.all
    # по умолчанию возвращает index.html.erb
  end
  # И создадим вид /app/views/articles/index.html.erb

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end


puts
puts '                                     Метод в модели для предсталения'

# По курсу Круковского на примере проекта AskIt

# модель
class Question < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # Создадим метод в модели
  def formatted_created_at
    self.created_at.strftime('%Y-%m-%d %H:%M:%S') # можно с self
    created_at.strftime('%Y-%m-%d %H:%M:%S') # но можно и просто тк created_at это инстанс метод модели
  end
end

# будем использовать метод в виде для форматирования даты например так:
question.created_at.formatted_created_at


puts
puts '                           PRG(Post Redirect Get). redirect_to. show(resourses)'

# При обновлениии страницы, возвращенной пост запросом(тут post '/articles' articles#create), произойдет повторная отправка формы(выскакивает предупреждение от браузера), тк возвращается вид на тот же URL, что может вызвать проблемы например 2йной покупки и 2йного списания денег

# PRG(Post Redirect Get) - паттерн для предотвращения двойного сабмитта. Тоесть POST-запрос вместо возврата вида совершает перенаправление на GET-запрос.

# Для этого в нашем случае добавим redirect_to @article в метод create
class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article  # перенаправляет на GET /article/id articles#show. Тогда вид create.html.erb будет уже не нужен.
      # redirect_to получает сущность из @article и делает редирект по ее айди. Редирект происходит на стороне браузера, те новый get-запрос.
    else
      render action: 'new'
    end
  end

  # Далее добавим метод show на который редиректит из create
  def show # get '/articles/id'
    @article = Article.find(params[:id]) # получаем id из URL через params
    # по умолчанию возвращает articles/show.html.erb
  end
  # Создадим представление /app/views/articles/show.html.erb

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end


puts
puts '                                     разница между render и redirect_to'

#  https://stackoverflow.com/questions/7493767/are-redirect-to-and-render-exchangeable

# render (?? возврат вида по умолчанию это тоже рендер ??) - когда пользователь обновляет страницу, он снова отправит предыдущий запрос POST. Это может привести к нежелательным результатам, таким как повторная покупка и другие. Соответвенно используем только в безопасных случаях, например когда не прошла валидация и данные не отправлены в БД

# redirect_to - когда пользователь обновляет страницу, он просто снова запросит ту же страницу. Это также известно как шаблон Post/Redirect/Get (PRG). После обработки post запроса браузеру возвращается маленький пакет(тк не содержит представлений итд, а только управляющую команду), браузер автоматически исполняет команду и отправляет GET-запрос

# В том числе и по этому в обработчиках GET-запросов не совершаюттся никакие опасные действия меняющие данные, чтобы обновления не привели к 2йным отправкам данных и пользователь мог переходить по страницам безопасно.


puts
puts '                          edit(resourses), update(resourses). Редактирование статьи'

# Добавим ссылку на редактирование в articles/index.html.erb

# Добавим в /app/controllers/articles_controller.rb:
def edit #  get '/articles/id/edit'
  @article = Article.find(params[:id])
  # по умолчанию возвращает edit.html.erb
end
# Создадим вид /app/views/articles/edit.html.erb c формой для редактирования

# Добавим в контроллер /app/controllers/articles_controller.rb экшен update
def update  # post -> put '/articles/id'
  @article = Article.find(params[:id])
  if @article.update(article_params) # тут метод update вместо метода save, который сохранял при создании сущности
    redirect_to @article # перенаправление на show  get '/articles/id'
  else
    render action: 'edit'
  end
end


puts
puts '                                 Удаление статьи(resourses/destroy)'

# Все что нужно для удаления сущности это ее id

# Можно удалать через Pэилс консоль:
@a = Article.find(10)
@a.destroy


# Есть несколько способов удаления: через форму или через кнопку(тут через кнопку)

# Добавим в файл articles/index.html.erb кнопку удаления статьи

# Добавим в articles_controller.rb метод destroy:
def destroy # post -> delete '/articles/id'
  @article = Article.find(params[:id]) # все что нам нужно для удаления это id
  @article.destroy

  redirect_to articles_path # перенаправляем на get '/articles' #index

  # по умолчанию возвращает destroy.html.erb
end


puts
puts '                               Контроллер и роутинг статических страниц(не по REST)'

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
get 'terms' => 'pages#terms'
get 'about' => 'pages#about', as: 'about'
# as: 'about' - для статических страниц создаются и хэлперы юрлов, тут about_path

# Создадим представления /app/views/pages/terms.html.erb и /app/views/pages/about.html.erb



















#
