puts '                                            Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides
# http://rusrails.ru/command-line   -   Rusrails: Командная строка Rails
# http://rusrails.ru/rails-routing  -  Rusrails: Роутинг в Rails


# (Не пробовал)
# В конспектах на гитхаб так же есть ruby через RVM и другие штуки:
# 	Установка ruby через RVM
# 		1. Посмотрим доступные версии Rails:  gem search '^rails$' --all
# 		2. Чтобы установить конкретную версию, введите (вместо rails_version - номер версии): gem install rails -v rails_version
# 		3. С помощью gemset-ов можно использовать вместе разные версии Rails и Ruby. Это делается с помощью команды gem.
# 			rvm gemset create gemset_name # create a gemset
# 			rvm ruby_version@gemset_name  # specify Ruby version and our new gemset
# 			Gemset-ы позволяют создавать полнофункциональные окружения для gem-ов, а также настраивать неограниченное количество окружений для каждой версии Ruby.
# https://github.com/DefactoSoftware/Hours


puts
puts '                                        Создание приложения'

# > rails new some_name   -  cоздаcт новое рейлс-приложение в выбранной папке(вручную ничего делать не нужно), где последнее слово на выбор это имя директории приложения(например blog). Устанавливаются все необходимое для работы приложения, гемы итд. В итоге появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
# f .git
# d app     -  содержит отдельные папки views, models, controllers
# d bin
# d config  -  конфигурация содержит, например: фаил boot.rb; папку enviroments с настройками для каждого из 3х видов окружения(development.rb, test.rb и production.rb); routes.rb - фаил для установки маршрутов;
# d db
# d lib
# d log
# d public
# d storage
# d test
# d tmp
# d vendor
# f .gitattributes
# f .gitignore
# f .ruby-version
# f config.ru
# f Gemfile
# f Gemfile.lock
# f Rakefile
# f README.md


puts
puts '                                  Запуск сервера и исправление ошибок винды'

# > rails s  (rails server| start rails s | start rails server) -  запуск сервера приложения, запускаем в папке приложения, иначе просто выдаст справку по командам.

# Если не запустится, установи nodejs(sudo apt-get install nodejs)

# (!!! На Виндоус(64), решение для Рэилс 7). По умодлчанию будет выдавать ошибку таймзон(tzinfo-data is not present. Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)), поэтому нужны манипуляции:
# 1. Изменить/подкрутить Gemfile.
  # Найти строки:
    # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
  # И удалить из аргументов обработчика gem второй аргумент полностью, останется только:
    gem 'tzinfo-data'
# 2. > gem uninstall tzinfo-data
# 3. > bundle install |или| > bundle update(лучше тк можно не писать gem uninstall tzinfo-data ??)

# (!!! Далее могут быть проблемы в Виндоус, если запустить приложение в PowerShell или Git Bash, тк у них проблемы с регистром(не воспринимают заглавные), потому нужно прописать вручную либо использовать классическую командную строку !!!)
# https://discuss.rubyonrails.org/t/getting-started-with-rails-no-template-for-interactive-request/76162


# Далее запускается Рэилс-сервер, среди прочего он говорит, что запускается на порту 3000(http://127.0.0.1:3000/)
# http://localhost:3000/  -  адрес для открытия рэилс приложений

# Последовательность того как начинает работу rails-приложение, когда его запускаешь:
# boot.rb -> rails -> environment.rb(подгружается) -> development.rb или test.rb или production.rb(подгружается окружение)


# Rails-приложение по умолчанию может запускаться в 3 разных типах окружения(режимах):
# 1. development - оптимизирует среду для удобства разработки, будет работать чуть медленнее.
# 2. test        - для тестирования
# 3. production  - запускает только то что нужно для работы приложения, работает максимально быстро
# Для каждого типа окружения существует своя отдельная БД

# Запуск окружения (development, test, production) через ключ -e (enviroment/окружение). По умолчанию окружение development
# > rails s -e development
# > rails s -e test
# > rails s -e production


puts
puts '                                             Ошибки разное'

# 1. tmp\pids\server.pid  # Автоматически удаляется когда закрываем сервер, но если что-то пошло не так и он не удалился, то сервер может перестать запускаться, тогда этот фаил нужно удалить вручную


puts
puts '                                             rails generate'

# generate - команда для запуска генераторов с различными параметрами

# > rails generate генератор параметры_генератора
# > rails g генератор параметры_генератора

# > rails g     # показывает список всех генераторов которые есть у нас в системе

# Виды генераторов(бывают как от самого Рэилс так и от различных гемов):
# controller - для генерации контроллеров(так же маршрутов и предсталений для них)
# model      - для генерации моделей и миграций
# migration  - генератор миграции, который создает миграцию без модели
# scaffold   - генератор одновременно для модели, контроллера, экшенов, маршрутов, представлений, тестов по REST resourses.
# ...


puts
puts '                                                  MVC'

# MVC(Model, View, Controller) - архитектура/паттерн, разделяющаяя приложение на 3 части, в каждой из которых высокая связанность, при слабой связанности самих частей
# Model      - бизнес логика, например работа с базами данных
# View       - виды представления, то что видит пользователь
# Controller - тонкая управляющая прослойка между Model и View, осуществляет их взимодействие

# В случае с Рэилс запрос браузера сначало попадает в Rails router(его конфигкрация находится в /config/routes.rb), а уже потом в контроллер, контроллер делает запрос к модели, модель обращается в БД, передает данные в виде сущности контроллеру, он передает их в представление и затем возвращает html сгенерированной страницы в браузер.


puts
puts '                                               Контроллеры'

# Controller - это специальный класс, который часто относится к какой-либо сущности, он находится в своем фаиле и отвечает за работу с URLом(и возвращаемыми видами для него).
# Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers
# Контроллеры, которые разнесены по разным фаилам содержат экшены.
# Экшен - это метод отвечающий за обработчик(get, post итд) какого-либо URL

# Контроллеры наследуются от ApplicationController, а ApplicationController наследуется от ActionController::Base
# ApplicationController(для наших кастомных методов ?) мы напишем метод и его унаследуют все наши контроллеры
# ActionController::Base - (для методов pзэилс ?) содержит методы params, respond_to итд

#> rails generate controller home index  -  Создадим контроллер. Тут: rails generate - команда создания чегото; controller - говорит о том что мы будем создавать контроллер; home - название контроллера ; index - action(название метода/действия). В отладочной инфе пишет все что добавилось. Мы создали:
# 1. фаил app/controllers/home_controller.rb В нем находится код:
class HomeController < ApplicationController # контроллер это класс
  def index # а действие это метод в этом классе(отвечающий за обработку запросов)
    # по умолчанию get 'home/index'
    # по умолчанию возвращает index.html.erb
  end
end
# 2. маршрут home/index
# 3. поддиректорию home и фаил index.html.erb в ней(app/views/home/index.html.erb)
# 4. тесты и хэлперы

# http://localhost:3000/home/index  -  теперь это представление можно открыть в браузере


puts
puts '                               rails routes. routes.rb - прописывание маршрутов'

# https://guides.rubyonrails.org/routing.html

# > rails routes  -  эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут. Удобно смотреть к каким контроллерам что ведет, если забыл.
# (До версии Rails 6.1 необходимо использовать команду: rake routes вместо rails routes.)

# Так же можно смотреть маршруты в браузере введя несуществующий URL(например в еще одном окне чтоб смотреть)

# Сами маршруты хранятся в config/routes.rb там их тоже можно посмотреть и изменить.

# Пропишем маршрут(закрепим обработчики URLов за опред экшенами). Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  # Обычно home#index создаётся для главной страницы сайта, поэтому нужно/можно поменять корневой маршрут и прописать в нем вместо get 'home/index'
  get '/' => 'home#index'  # Обычный подход без REST, определяем маршрут вручную
  # Тут мы направили обработчик URL get '/' в метод/экшен index контроллера home

  root "home#index" # альтернатива ??
  root to: "home#index" # to: "home#index" - аргумент хэш
end


puts
puts '                                    Модели и миграции(ActiveRecord)'

# Модели наследуются от ActiveRecord::Base
# ActiveRecord::Base - (для методов AR ?) содержит has_many, validates итд

# Создание модели(В Синатре была в app.rb, в Рэилс в каталоге app) и миграции, таблицы, БД:

# А. > rails g model Article title:string text:text    -   Создадим модель и миграцию: rails g(generate) - команда создания чегото; model - генератор модели, значит что создаем модель; Article - название модели(тот класс что отвечает за сущности); title:string text:text - свойства класса модели, те столбцы таблицы и типы данных для них;
# После запуска при помощи active_record будет автоматически созданы и описаны в выводе:
# 1. миграция(с уже заполненным методом change)   db/migrate/20230701043625_create_articles.rb
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text

      t.timestamps  # создан автоматически без необходимости указания в команде генерации модели
    end
  end
end
# 2. фаил модели(В Синатре была в app.rb)  app/models/article.rb
class Article < ApplicationRecord
end
# 3. юнит тесты.

# Б. rake db:migrate    -   далее выполняем миграцию.
# База данных находится/создается в каталоге db/development.sqlite3


# Примечание. Почти всегда таблица это множественное число от модели, но иногда Рэилс делает нестандартно, например для модели Person создаст таблицу people а не persons
# В книге Rails. Гибкая разработка веб-приложений (Руби, Томас, Хэнссон) можно прочитать про соглашения об именах.


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
    # render - метод для возврата данных из экшена; plain: params[:article].inspect - параметр функции render; plain: - ключ хеша(обозначает что будет выведен просто текст); params[:article].inspect - значение хеша. В итоге выведет #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.

    # по умолчанию возвращает create.html.erb
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
puts '                                              Rails console'

# Консоль Рэилс похожа на tux что мы использовали в Синатре, работает точно так же. Можно писать в ней любой рубикод

# > rails console  -  вход в консоль
# > rails c  -  вход в консоль
# exit  -  выход

# Примеры работы:
Contact.all #=> SELECT "contacts".* FROM "contacts"  => []
Article.find(6) #=> SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 6], ["LIMIT", 1]]
Contact.attribute_names #=> ["id", "email", "message", "created_at", "updated_at"] # узнать какие свойства(поля) у сущности


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

  def contact_params # название метода обычно такое(названиесущности_params), хотя можно любое
    params.require(:contact).permit(:email, :message) # permit(:email, :message) - содержит все столбцы
  end
end
# Теперь мы можем добавить запись в БД через форму /contacts/new


puts
puts '                            Реализация объекта params и разрешения параметров'

# params - объект(хэш хэшей) который по умолчанию присутсвует(переходит при наследовании из ApplicationController) в контроллере(можно обратиться к нему из любого метода в контроллере), в нем хранятся все параметры которые передаются из браузера в приложение.
# https://api.rubyonrails.org/classes/ActionController/Parameters.html -  реализация params в ActionController
params = ActionController::Parameters.new({
  person: {
    name: "Francesco",
    age:  22,
    role: "admin"
  }
})

params = ActionController::Parameters.new
params.permitted? # => false  # проверяем разрешен или нет только что созданный params, автоматически проверяется методами(методами сущности а не контроллера) изменяющими БД: save, create, updste, destroy

# require(:contact) - требует наличия параметров.
# https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-require
ActionController::Parameters.new(person: { name: "Francesco" }).require(:person) #=> #<ActionController::Parameters {"name"=>"Francesco"} permitted: false>

# permit(:email, :message) (изменяет значение метода permitted? на true)
# https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit
params = ActionController::Parameters.new(user: { name: "Francesco", age: 22, role: "admin" })
permitted = params.require(:user).permit(:name, :age)
permitted.permitted?      # => true
permitted.has_key?(:name) # => true
permitted.has_key?(:age)  # => true
permitted.has_key?(:role) # => false

# Тоесть тут мы разрешили только параметры name и age для сущности user. И теперь если хакер захочет админские права и нам передать в запросе чтото вроде:
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
    # а если не валидно вернем нашу форму new.html.erb(но уже на ЮРЛ /contacts) при помощи render
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

# Способ 1.
# Так пользователь получит вид и при GET запросе и на http://localhost:3000/contacts/new и на http://localhost:3000/contacts
Rails.application.routes.draw do
  # ... какието маршруты ...
  get 'contacts' => 'contacts#new'  # добавим обработку запроса get 'contacts' в экшен new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
end
# Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю стоку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

# Способ 2. Лучше тк меняет имя хэлпера и не будет ошибок, например с приемочными тестами:
# Так пользователь получит вид при GET запросе только на http://localhost:3000/contacts
Rails.application.routes.draw do
  # ... какието маршруты ...
  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути: path_names: { :new => '' } (По умолчанию был { :new => '/new' }). Те убирая путь для new, получается что он будет перенаправляться по базовому пути, а базовый путь для контроллера contacts это как раз /contacts
end


puts
puts '                                    Вывод списка статей(resourses/index)'

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
  # отвечает за GET-обработчик с URL /articles в resources экшен index

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
puts '                           redirect_to PRG(Post Redirect Get). show(resourses)'

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

  # Далее добавим метод show на который редиректит create
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
puts '                          Редактирование статьи(resourses/edit, resourses/update)'

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
get 'about' => 'pages#about'

# Создадим представления /app/views/pages/terms.html.erb и /app/views/pages/about.html.erb

# Для статических страниц создаются и хэлперы юрлов, например terms_path


puts
puts '                                             helpers(Хелперы)'

# http://rusrails.ru/action-view-overview
# https://guides.rubyonrails.org/form_helpers.html

# Для каждого нового контроллера создается хелпер. Все хелперы расположены в каталоге /app/helpers/
module ArticlesHelper # хэлпер(является модулем) для контроллера Articles /app/helpers/articles_helper.rb
  # тут можно писать методы
end
# Один хелпер создаётся для одного контроллера, но все хелперы доступны всем контроллерам.

# ?? Методы хэлперлов не действуют внутри контроллеров

# Хелпер - работает между контроллером и представлением. Чтобы не вставлять код в представление:
# В представлениях часто нужно писать какието участки кода, которые повторяются для разных представлений, тк на один контроллер у нас может быть несколько представлений(например у нас 5 представлений для контроллера Articles). Тк нет смысла дублировать один и тот же код во многих представлениях, то проще записать его в методе в хэлпере вызывать хэлпер в представление

# Логику в представлениях писать непринято, лучше выносить в хелперы. Представления предназначены для того, чтобы отображать данные. Нехорошо размазывать логику по всему приложению, лучше держать в одном месте(например в контроллерах).
# Много кода в представлении будет мешать фронтэндерам
# Код в представлениях трудно тестировать


puts
# Существуют также встроенные хелперы в Rails, например:

# debug, тут выведет список параметров, чтобы их отслеживать
<%= debug(params) %>

# Преобразует введенный(например в поле) текст(@foo) в html, например заменяет "\n" на <br>
<%= simple_format(@foo) %>

# автоматическая подсветка ссылок - autolinks

# А, также truncate - если есть длинная строка, то обрезается на строки под указанный размер:
<%= truncate(@foo, length: 20) %>

# link_to - позволяет вставлять ссылки и задавать им параметры( работает совместно с js-фаилом turbolinks)
<%= link_to "Sign In", new_user_session_path %>


puts
puts '                                           Отправка e-mail'

# У отправки имэила(Transactional emails) непростая структура. Для отправки необходимо обратиться к серверу и нужно гдето его взять.
# Transactional emails - имэйлы которые реагируют на определенные события в нашем сайте(напр пользователь написал коммент)

# SMTP-сервер. Где его взять:
# 1. администратор нашей компании - лучший вариант, не нужно ебаться
# 2. хостинг - (плохой варик)большой процент попадания в спам. если мы отправляем много сообщений, хостинг может послать нах
# 3. gmail - надо включить options, есть ограничения по количесву писем в день, иначе лавочку закроет

# postmarkapp (платно) - для Transactional emails, но через него нельзя делать почтовую рассылку. Письма должны быть с кнопкой Unsubscribe, чтобы не попасть в черный список. Не использует ActionMailer::Base из Рэиллс, тк сервер не SMTP(хотя может) а через данный сайт.


# bulk email messaging - для рассылки

# Если перепутать Transactional emails и bulk email, то IP адрес может попасть в черный список


# https://postmarkapp.com/developer/user-guide/sending-email/sending-with-api
# https://github.com/wildbit/postmark-gem
# https://github.com/wildbit/postmark-rails
# http://rusrails.ru/action-mailer-basics
# https://www.youtube.com/watch?v=FNOhpAWbiKA
# https://github.com/mikel/mail


















#
