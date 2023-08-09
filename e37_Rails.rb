puts '                                            Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides

# > rails new some_name   -  cоздаcт новое рейлс-приложение в выбранной папке(вручную ничего делать не нужно), где последнее слово на выбор это имя директории приложения(например blog). Устанавливаются все необходимое для работы приложения, гемы итд. В итоге появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
# f .git
# d app   -  содержит отдельные папки views, models, controllers
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

# На Виндоус(64), для Рэилс 7. По умодлчанию будет выдавать ошибку таймзон(tzinfo-data is not present. Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)), поэтому нужны манипуляции:
# 1. Изменить/подкрутить Gemfile.
  # Найти строки:
    # # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    # gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
  # И удалить из аргументов обработчика gem второй аргумент полностью:
    # удаляем: ", platforms: [:mingw, :mswin, :x64_mingw, :jruby]"
    # останется только: "gem 'tzinfo-data'
# 2. > gem uninstall tzinfo-data
# 3. > bundle install |или| > bundle update

# (!!! Далее могут быть проблемы в Виндоус, если запустить приложение в PowerShell или Git Bash, тк у них проблемы с регистром(не воспринимают заглавные), потому нужно прописать вручную либо использовать классическую командную строку !!!)
# https://discuss.rubyonrails.org/t/getting-started-with-rails-no-template-for-interactive-request/76162


# Далее запускается Рэилс-сервер, среди прочего он говорит, что запускается на порту 3000(http://127.0.0.1:3000/)
# http://localhost:3000/  -  адрес для открытия рэилс приложений

# Последовательность того как начинает работу rails-приложение, когда его запускаешь:
# boot.rb -> rails -> environment.rb(подгружается) -> development.rb или test.rb или production.rb(подгружается окружение)


# Rails-приложение по умолчанию может запускаться в 3 разных типах окружения(режимах):
# 1. development - оптимизирует среду для удобства разработки, будет работать чуть медленнее.
# 2. test - для тестирования
# 3. production - запускает только то что нужно для работы приложения, работает максимально быстро
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
# controller - для генерации контроллеров
# model      - для генерации моделей и миграций
# migration  - генератор миграции, который создает миграцию без модели
# ...


puts
puts '                                                  MVC'

# MVC(Model, View, Controller) - архитектура/паттерн, разделяющаяя приложение на 3 части, в каждой из которых высокая связанность, при слабой связанности самих частей
# Model  -  бизнес логика, например работа с базами данных
# View - виды представления, то что видит пользователь
# Controller - тонкая управляющая прослойка между Model и View, осуществляет их взимодействие


puts
puts '                                               Контроллеры'

# Controller - это специальный класс, который обычно относится к какой-либо сущности, он находится в своем фаиле и отвечает за работу с URLом(и возвращаемыми видами для него).
# Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers
# Контроллеры, которые разнесены по разным фаилам содержат экшены/методы.
# Экшен - это метод отвечающий за обработчик(get, post итд) какого-либо URL

#> rails generate controller home index  -  Создадим контроллер. Тут: rails generate - команда создания чегото; controller - говорит о том что мы будем создавать контроллер; home - название контроллера ; index - action(название метода/действия). В отладочной инфе пишет все что добавилось. Мы создали:
# 1. фаил app/controllers/home_controller.rb В нем находится код:
class HomeController < ApplicationController # контроллер это класс
  def index # а действие это метод в этом классе(отвечающий за обработку запросов)
    # по умолчанию get-обработчик 'home/index'
    # по умолчанию возвращает index.html.erb
  end
end
# 2. маршрут home/index
# 3. поддиректорию home и фаил index.html.erb в ней(app/views/home/index.html.erb)
# 4. так же различные тесты и хэлперы

# http://localhost:3000/home/index  -  теперь это представление можно открыть в браузере(почему то иногда не открывается до изменения маршрута в config/routes.rb) ??


puts
puts '                               rails routes. routes.rb - прописывание маршрутов'

# https://guides.rubyonrails.org/routing.html

# > rails routes  -  эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут. Удобно смотреть к каким контроллерам что ведет, если забыл.

# Так же можно смотреть маршруты в браузере введя несуществующий URL(например в еще одном окне чтоб смотреть)

# (До версии Rails 6.1 необходимо использовать команду: rake routes вместо rails routes.)

# Сами маршруты хранятся в config/routes.rb там их тоже можно посмотреть и изменить.

# Пропишем маршрут(закрепим обработчики URLов за опред экшенами). Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  # Обычно home#index создаётся для главной страницы сайта, поэтому нужно/можно поменять корневой маршрут и прописать в нем вместо get 'home/index'
  get '/' => 'home#index'  # Обычный подход без REST, определяем маршрут вручную
  # Тут мы направили обработчик URL get '/' в метод/экшен index контроллера home(?? или наоборот экшен отправляется в лямбду-параметр обработчика ??)
end


puts
puts '                                    Модели и миграции(ActiveRecord)'

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

# Теперь можно добавлять в представление HTML-код. Все работает.


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

# 4. Создадим представление new.html.erb в дирректории contacts

# 5. Создаем модель и миграцию и запускаем миграцию.
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

# 6. Заполняем(формой) contacts/new.html.erb

# 7. Добавим предствление /app/views/contacts/create.html.erb


puts
puts '                                              Rails console'

# Консоль Рэилс похожа на tux что мы использовали в Синатре, работает точно так же. Можно писать в ней любой рубикод

# > rails console  -  вход в консоль
# exit  -  выход

# Примеры работы:
Contact.all #=> SELECT "contacts".* FROM "contacts"  => []
Article.find(6) #=> SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT ?  [["id", 6], ["LIMIT", 1]]
Contact.attribute_names #=> ["id", "email", "message", "created_at", "updated_at"] # узнать какие свойства(поля) у сущности


puts
puts '                             Запись в БД. Разрешение на использование атрибутов'

# Откроем /app/controllers/contacts_controller.rb и запишем код, но...
class ContactsController < ApplicationController
  def new
  end
  def create # принимает данные введенные пользователем в форму
    @contact = Contact.new(params[:contact])
    @contact.save
  end
end
# Но если больше ничего не добавлять то при нажатии кнопки формы вылезет ошибка: ActiveModel::ForbiddenAttributesError in ContactsController#create - т.к. аттрибуты(params[:contact]) по умолчанию запрещены - связано с безопасностью. Все атрибуты изначально запрещенные и их нужно разрешить, для этого используется специальный синтаксис:
class ContactsController < ApplicationController
  def new
  end

  def create
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

# Сейчас у нашего блога при ручном заходе(GET) на /contacts выпадает Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик(create). Сделаем так, чтобы GET '/contacts' у нас обрабатывался в экшене new, соотв возвращался вид new.html.erb с формой.
# У resource по этому запросу по умолчнию show.

# Откроем /config/routes.rb и добавим код:

# Способ 1.
# Так пользователь получит вид и при GET запросе и на http://localhost:3000/contacts/new и на http://localhost:3000/contacts
Rails.application.routes.draw do
  # ... какието маршруты ...

  get 'contacts' => 'contacts#new'  # добавим обработку запроса get 'contacts' в экшен new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
end
# Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю стоку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

# Способ 2. (в одну строку):
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
    else
      render action: 'new'
    end
  end
  # Теперь нам надо создать представление для create. Создадим: /app/views/articles/create.html.erb
  # Добавим ссылку в create.html.erb на все статьи '/articles'
  # При переходе на нее получим - Unknown action The action 'index' could not be found for ArticlesController тк нет метода для GET-обработчика по адресу /articles (который в resources является index)

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
      redirect_to @article  # перенаправляет на GET /article/id articles#show. Тогда представление create.html.erb нам будет уже не нужно и можно его удалить.
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


puts
puts '                                 Удаление статьи(resourses/destroy)'

# Все что нужно для удаления сущности это ее id

# Можно удалать через Pэилс консоль:
# irb(main):004:0> @a = Article.find(10)
# irb(main):005:0> @a.destroy


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
puts '                               one-to-many. На примере Article 1 - * Comment'

# Схема one-to-many: Article 1 - * Comment. Тоесть сущность(таблица, может быть связана со многими комментариями для нее)

# https://railsguides.net/advanced-rails-model-generators/
# https://guides.rubyonrails.org/association_basics.html
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html

# Полезная особенность генераторов, возможность указывать reference columns - делать ссылки на другие сущности

# 1. Создадим модель Comment со ссылкой на article:
# > rails g model Comment author:string body:text article:references
# article:references - дополнительный параметр, отвечающий за отношение между сущностями
# /models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :article # модель создалась с этим. Тоесть комментарии принадлежат статье. можно добавлять вручную если в генераторе не указать article:references
end
# /db/migrate/12312314_create_comments.rb:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :body
      t.references :article, null: false, foreign_key: true # создало в миграции эту строку - связь по айди для комментов с какойто статьей, те поле для id статьи к которой относится коммент. Создает столбец article_id являющийся foreign_key к id в таблице articles.
      #Тоже можно добавлять отдельной миграцией если в генераторе не указать article:references ??
      # можно добавить в ручную если данная миграция не была запущена

      t.timestamps
    end
  end
end
# rake db:migrate


# 2. Допишем вручную в модель уже Article  /models/article.rb ...
class Article < ApplicationRecord
  has_many :comments # ... тоесть статья связывается с комментами
end
# Таким образом мы связали 2 сущности между собой.


# 3. Напишем маршрут. У нас в /config/routes.rb есть строка:
resources :articles
# Изменим ее и сделаем вложенный маршрут:
resources :articles do
  resources :comments # создает список маршрутов по REST, но вложенный(одни ресурсы в других)
end
# Команда rails routes покажет нам карту маршрутов для comments.
# article_comments     GET      /articles/:article_id/comments(.:format)          comments#index
# new_article_comment  GET      /articles/:article_id/comments/new(.:format)      comments#new
#                      POST     /articles/:article_id/comments(.:format)          comments#create
# article_comment      GET      /articles/:article_id/comments/:id(.:format)      comments#show
# edit_article_comment GET      /articles/:article_id/comments/:id/edit(.:format) comments#edit
#                      PATCH    /articles/:article_id/comments/:id(.:format)      comments#update
#                      PUT      /articles/:article_id/comments/:id(.:format)      comments#update
#                      DELETE   /articles/:article_id/comments/:id(.:format)      comments#destroy
# Тут article_id то что в маршрутах articles являлось id, тут id это айди коммента


# 4. Добавляем контроллер для комментариев
# > rails g controller Comments
# Для комментариев нам(тут) нужен только один метод - create, тк не будем с ним больше ничего делать, кроме добавления(POST), а форма для него и вывод будут на странице статьи к которой он относится(article#show).

# Посмотрим в rails console:
Article.comments  #=> будет ошибка говорящая что у модели нет такого свойства comments
@article = Article.find(1) #=> но если создать обект с одной статьей ...
@article.comments #=> ... то ошибки уже не будет. Те мы получаем доступ к списку комментов для этой статьи
@article.comments.create(:author => 'Foo', :body => 'Bar') #=> создание коммента для данной статьи, через сущность статьи

class CommentsController < ApplicationController
  # Создадим метод create в /app/controllers/comments_controller.rb:
  def create # post '/articles/:article_id/comments'
    @article = Article.find(params[:article_id]) # :article_id тк это контроллер Comments и его карта маршрутов
    @article.comments.create(comment_params) # создаем комментарий через сущность статьи

    redirect_to article_path(@article) # get '/articles/id'  articles#show
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :body)
  end
end


# 5. Добавим форму для комментариев на '/articles/id'  show.html.erb
# Добавим комменты и посмотрим в рейлс-консоли:
Comment.last
Comment.all  # все комменты ко всем статьям
@article = Article.find(1)
@article.comments #=> Все комменты относящиеся к статье из сущности @article
# Вывод комментариев там же


puts
puts '                                               Типы связей(AR)'

# Существует множество типов связей, но среди них есть 3 основные: one-to-many, one-to-one, many-to-many
# http://rusrails.ru/active-record-associations

# 1. one-to-many (1 - *)
# Article            |  Comment
# has_many :comments |  belongs_to :article
# id                 |  id, article_id

# 2. one-to-one (1 - 1) - помогает нормализовать БД(не нужно в orders держать все поля адреса, а только айди отдельно сделанной для этого таблицы. Те делим данные из формы на 2 связанные таблицы для удобства)
# Order              |  Address
# has_one :address   |  belongs_to :order
# id                 |  id, order_id
# Нормализация - разбитие на подтаблицы, денормализация - обобщение в одну таблицу. Минус нормализованного подхода в усложнении SQL запроса, иногда может повлиять на скорость.

# 3. many-to-many (* - *) - Есть статьи и теги(категории), у каждого тега есть много статей и у каждой статьи есть много тегов. для связи между ними создаётся ещё одна таблица tags_articles состоит только из 2х столбцов tag_id, article_id, тк недостаточно 2х таблиц для реализации. В Рэилс доп таблица создается автоматически
# Tag                               |                        |  Article
# таблица tags                      |  таблица tags_articles |  таблица articles
# id                                |  tag_id, article_id    |  id
# has_and_belongs_to_many :articles |                        |  has_and_belongs_to_many :tags

# Изучить: http://www.rusrails.ru/active-record-associations#foreign_key


puts
puts '                                            CRUD(ActiveRecord)'

# CRUD(основыные операции):
# Create - (new) - .create ; .new.save
# Read - .where; .find(3); .all
# Update - (update)
# Delete - (destroy)

# https://github.com/rails/strong_parameters
# https://guides.rubyonrails.org/action_controller_overview.html#more-examples


puts
puts '                                               Devise'

# Devise - гем для авторизации

# https://github.com/plataformatec/devise                             -  Документация по гему devise
# https://habr.com/ru/post/208056/                                    -  Статья на Хабре по devise
# https://github.com/plataformatec/devise/wiki/Example-applications   -  Посмотреть примеры как используется

# Инфа от установщика по донастройке:
# https://github.com/heartcombo/devise/blob/main/CHANGELOG.md
# https://github.com/heartcombo/devise/wiki/How-To:-Upgrade-to-Devise-4.9.0-%5BHotwire-Turbo-integration%5D


# Добавление/подключение в Рэилс приложение:

# 1. Добавим в Gemfile строчку(в конец или начало, не важно):
gem 'devise'

# 2. Запускаем команду
# > bundle

# > rails g    # Проверим какие у нас появились в системе новые генераторы для работы с Devise.
# Devise:
#   devise
#   devise:controllers
#   devise:install
#   devise:views
# Те у нас появился генератор Devise с 4мя опциями(так же добавились devise-опции и в другие разделы)

# 3. Введём:
# > rails g devise:install
# Создались config/initializers/devise.rb  и  config/locales/devise.en.yml.
# Так же вывелись подсказки по настройкам, воспользуемся ими:

#     3-1. Добавим строку(если ее нет) в фаил config/environments/development.rb:
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # в значении наш локальный адрес

#     3-2. Проверить, что в /config/routes.rb указано(добавить если нет):
root to: "home#index"

#     3-3. Добавить(если нет) в Лэйаут нашего приложения app/views/layouts/application.html.erb. Нужно для работы технологии флеш-сообщений:
# <p class="notice"><%= notice %></p>
# <p class="alert"><%= alert %></p>

#     3-4(Это делали ниже а не тут). Для кастомизации форм(можно сделать свои шаблоны для форм(логина, пароля итд) которые выдает гем):
# > rails g devise:views


# !!! После добавления и настройки Devise необходимо перезапустить приложение, иначе возникнут ошибки


puts
# Далее, создадим модель пользователя но при помощи генератора devise вместо model(так модель сразу создастся со всеми полезными свойствами для авторизации: e-mail, зашифрованный пароль, токен для сброса пароля, индексы для таблиц итд итп):
# > rails g devise User
# Создались миграция db/migrate/20230721073907_devise_create_users.rb
class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token   # токен(символьный код) для сброса пароля
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # ... Так же много еще закоментированных разделов которые тут удалил чтоб не занимало место ...

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
# Модель app/models/user.rb(с опциями: регистрация, восстановление пароля итд итп)
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end

# Запустим миграцию:
# > rake db:migrate


puts
# Задача: чтобы мы могли просматривать статьи(/articles), но не могли их создавать(/articles/new), как будто неавторизированный пользователь:

# 1. Начнем с того что заблокируем все экшены контроллера даже просмотр(/articles) для неавторизированных пользователей
# Откроем /app/controllers/articles_controller.rb и добавим перед экшенами:
# (Примечание: начиная с Rails 5 синтаксис before_filter устарел(раньше были просто алиасоми) и заменён на before_action, как и многие другие свойства включавшие в имени filter)
class ArticlesController < ApplicationController
  before_action :authenticate_user! # это значит что для доступа ко всем методам контроллера использовать фильтр(из гема devise) :authenticate_user!. Тоесть все методы контроллера будут недоступны неавторизованному юзеру и при запрсах будет перенаправлять на форму регистраци/авторизации devise

  # ... Экшены итд ...
end
# Теперь когда мы переходим на /articles то автоматически переходит на /users/sign_in и возвращает нам уже готовую стандартную форму devise для регистрации(sign up)/авторизации(sign_in).
# Далее мы можем зарегистрироваться(наша сущность User сохранится в БД) и тогда получим доступ к экшенам


# 2. Добавим ссылки входа и выхода в /app/views/layouts/application.html.erb

# Ссылка выхода по умолчанию не работала(?? по умочанию пост а нужен гет ??), необходимо в route.rb:
devise_for :users # после этой строки...
# написать еще маршрут:
devise_scope :user do
  get '/users/sign_out' => 'devise/sessions#destroy'
end
# + В config/initializers/devise.rb изменить значение config.sign_out_via
config.sign_out_via = :delete # было это
config.sign_out_via = :get    # изменить на это


puts
puts '                                         Авторизация, сессии'

# Аутентификация - проверка пользователя и пароля
# Авторизация - наделение определёнными правами в зависимости от роли (юзер/админ)

# Тк HTTP это протокол staytless(без состояния), потому после того как сервер возвращает на запрос пользователя данные, соединение сразу обрывается. Но тем не менее и со стороны сервера и пользователя пользователь останется залогинен в системе. Соотв технология логина не зависит от соединения.

# Работа технологии: для того чтобы авторизоваться, пользователь подключается к серверу, посылает свой логин и пароль, а сервер возвращает ему Cookie(токен). Cookie является уникальной. Cookie остается у пользователя. Далее когда от данного пользователя поступает следующий запрос, то вместе с ним посылается эта уникальная Cookie, по ней сервер определяет состояние пользователя. Когда пользователь разлогинивается эта Cookie удаляется. Тоесть куки тут это временный идентификатор пользователя.

# Сервер распознает Cookie с помощью криптографических алгоритмов, которые не требуют обращения к БД.
# Механизм шифрования основан на цифровой подписи. В Rails главный секретный ключ(нужен чтобы устанавливать куки для пользователей) config.secret_key =(изначально закоменчен) находится /config/initializers/devise.rb
# (можно залогиниться автоматически не зная логина и пароля но зная куки для сайта, пока не было разлогина и если куки не привязаны к айпи адресу)


# Механизм сессий(происходит без авторизации)
# ?? в Рэилс приложении это хэш(для каждого пользователя разный)
session['key'] = 'value'
# Механизм сессий выдает Cookie пользователю при первом обращении к серверу, и затем без авторизации идёт обмен данными. Так сервер будет отличать неавторизованных пользователей, например для корзины товаров итд.
# Минус сессий в том что они иногда могут быть обнулены, например при перезапуске сервера


puts
puts '                                          Devise: username'

# Добавление username в наш блог, и вставка username залогиненого пользователя(которое будет подставляться автоматически) вместо поля автора комментария в форме комментариев:


# 1. Добавим руками столбец username тк Devise по умолчанию(тут в таблице users модели User) не создает столбец username(Можно было использовать и email который есть по умолчанию, но логичнее использовать username для комментов в блоге)

# https://api.rubyonrails.org/classes/ActiveRecord/Migration.html

# rails g migration - генератор миграции, который создает миграцию без модели(как в Синатре ?). При помощи него добавим в существующую таблицу users новый столбец, для этого создадим новую миграцию add_username(назвать можно как угодно):
# > rails g migration add_username
# /db/migrate/20190129063426_add_username.rb
class AddUsername < ActiveRecord::Migration[7.0] # Теперь при помощи этой миграции мы можем добавлять в любые таблицы любые новые столбцы
  def change # метод change изначально не заполнен
    # Далее вручную заполняем чтобы добавить столбец username в таблицу users:
    add_column :users, :username, :string # add_column - метод для создания столбца(одного отдельного, для другого нужно писать еще раз add_column ...), первый аргумент имя таблицы, 2й имя столбца, 3й тип данных для столбца, 4м можно поставить значение по умолчанию

    # По умолчанию можно будет вставить в этот столбец неуникальный username(те может быть 2+ одинаковых). Чтобы это исправить создадим на уровне БД уникальный индекс, который означает, что в этот столбец можно будет вставить только уникальные значения, если будем вставлять неуникальные, то ошибка будет уже на уровне БД
    # Индекс - это когда для нашей таблицы создается доп таблица, с указателями для более быстрого выбора записей по ключу(полю). Для полей с индексами увеличивается время вставки, но уменьшается время выборки по определённому полю.
    add_index :users, :username, unique: true
    # Так же можно добавить и в отдельной миграции(например назвать ее add_index)
  end
end
# > rake db:migrate

# Тоже самое можно было сделать изначально дописав нужное поле в фаиле миграции модели User, перед тем как запустили миграцию


# 2. Обновим материнский контроллер ApplicationController для того чтобы в devise можно было использовать username:
# Все контроллеры наследуются от базового контроллера ApplicationController(является базовым классом от которого наследуют остальные классы контроллеры, не имеет своего маршрута) и чтобы задать для всех контроллеров один параметр(например есть какието гемы, как Девайс, требующие особого поведения, то это поведение задается в базовом контроллере, а остальные его наследуют), надо прописать это в ApplicationController. /app/controllers/application_controller.rb:
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller? # фильтр :configure_permitted_parameters будет выполнен только для devise контроллеров. Девайс контроллер это тот где у нас работает девайс( ?? а мб только базовые Devise-контроллеры ?? тут это Articles, тк там подключен девайс при помощи before_action :authenticate_user)!

  protected #private

  # Для Devise надо указать какие дополнительные параметры можно задать.
  def configure_permitted_parameters # метод фильтра с настройками разрешений
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username]) # где :sign_up раздел(тут форма для регистрации нового пользователя), keys: [:username] - то что добавляем в этот раздел. Тоесть мы разрешаем добавление параметра :username для формы :sign_up. или для занесения в БД из этой формы ?? Тоесть чтобы при регистрации теперь спрашивало username

    # Эти не использовали но как вариант других разделов
    # devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    # devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end


# 3. Далее, отредактируем форму регистрации Sign Up, для того чтоб там появилось поле для username:
# Но по умолчанию в каталоге views раздела и представлений для devise нет, поэтому сгенерируем набор views:
# > rails g devise:views
# Команда автоматически создает множество директорий и фаилов в views в новой подпапке devise, в том числе и фаил отвечающий за представление с нужной нам формой регистрации. Теперь мы можем эти представления изменять

# Теперь добавим для sign up код поля ввода username в /app/views/devise/registrations/new.html.erb
# В лэйаут выведем имя вместо e-mail в приветсвии рядом с Sign Out в /app/views/layouts/application.html.erb


# 4. Подкорректируем контроллеры Articles и Comments, чтобы они запрещали доступ незарегистрированным пользователям только к функционалу(создание, изменение, удаление статей и комментов), но разрешали по умолчанию доступ к просмотру статей и комментов
class ArticlesController < ApplicationController
  # Авторизация только для создания и редактирования статьи /app/controllers/articles_controller.rb:
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

  # ... Экшены итд ...
end
class CommentsController < ApplicationController
  # Авторизация только для создания комментария /app/controllers/comments_controller.rb:
  before_action :authenticate_user!, :only => [:create]

  # ... Экшены итд ...
end


# 5. Сделаем так, чтобы при комментировании статьи автор указывался тот, кто залогинен(articles/show.html.erb)


puts
puts '                                             helpers(Хелперы)'

# http://rusrails.ru/action-view-overview
# https://guides.rubyonrails.org/form_helpers.html

# Для каждого нового контроллера создается хелпер. Все хелперы расположены в каталоге /app/helpers/
module ArticlesHelper # хэлпер(является модулем) для контроллера Articles /app/helpers/articles_helper.rb
  # тут можно писать методы
end
# Один хелпер создаётся для одного контроллера, но все хелперы доступны всем контроллерам.

# Хелпер - работает между контроллером и представлением. Чтобы не вставлять код в представление:
# В представлениях часто нужно писать какието участки кода, которые повторяются для разных представлений, тк на один контроллер у нас может быть несколько представлений(например у нас 5 представлений для контроллера Articles). Тк нет смысла дублировать один и тот же код во многих представлениях, то проще записать его в методе в хэлпере вызывать хэлпер в представление

# Логику в представлениях писать непринято, лучше выносить в хелперы. Представления предназначены для того, чтобы отображать данные. Нехорошо размазывать логику по всему приложению, лучше держать в одном месте(например в контроллерах).

# Много кода в представлении будет мешать фронтэндерам

# Код в представлениях трудно тестировать


puts
# Существуют также встроенные хелперы в Rails:

# debug, тут выведет список параметров, чтобы их отслеживать
<%= debug(params) %>

# Преобразует введенный(например в поле) текст(@foo) в html, например заменяет "\n" на <br>
<%= simple_format(@foo) %>

# И, см. автоматическая подсветка ссылок - autolinks

# А, также truncate - если есть длинная строка, то обрезается на строки под указанный размер:
<%= truncate(@foo, length: 20) %>

# link_to - позволяет вставлять ссылки и задавать им параметры( работает совместно с js-фаилом turbolinks)
<%= link_to "Sign In", new_user_session_path %>


puts
puts '                      User 1 - * Article. Возможность удалить и редактировать только автору'

# Привяжем сущность article в блоге к пользователю user. Сделать так, чтобы другие пользователи не могли редактировать и удалять статьи.
# stackoverflow.com/questions/46633649/how-to-allow-users-to-only-see-edit-and-delete-link-if-the-article-is-their-own


# 1. Свяжем сущности User и Article
# /models/article.rb:
class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments#, dependent: :destroy    # было в комментах к уроку 46 хз зачем

  belongs_to :user, optional: true # добавим вручную;
  # optional: true - если это не добавить то при использовании Rails 5.1 и выше создание новой статьи и тесты(валидации ??) выдадут ошибку "User must exist"
end

# Добавим foreign key отдельной миграцией
# > rails g migration add_fk_article_to_user
# /db/migrate/20230804075512_add_fk_article_to_user.rb
class AddFkArticleToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :user # синтаксис для добавления foreign key
  end
end
# > rake db:migrate

#  /models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles # добавим вручную
end


# 2. Маршруты менять не будем тк сущность User от Devise со своими маршрутами и вкладывать в них нет смысла


# 3. В aticles/new.html.erb добавим скрытое поле с user_id залогиненного пользователя


# 4. В контроллере article#new добавим:
class ArticlesController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]
  # before_action :owner?, only: %i[edit destroy]  # в примере предлагалось так вместо вызова метода в экшенах но чето не работает

  # ... экшены

  def edit
    @article = Article.find(params[:id])
    owner? # вызываем метод после определения переменной тк с ней мы сравниваем current_user
  end

  # ... экшены

  def destroy
    @article = Article.find(params[:id])
    owner? # вызываем метод после определения переменной тк с ней мы сравниваем current_user
    @article.destroy
    redirect_to articles_path
  end

  private
  # добавим разрешения для нового поля user_id в article_params
  def article_params
    params.require(:article).permit(:title, :text, :user_id)
  end
  # добавим кастомный метод перенаправления(переправит на главную get '\') если ктото решит перейти не по ссылке а ввести юрл
  def owner?
    unless current_user == @article.user  # тут тоже без обращения к айди удобнее
      # @article.user через объект сущности статьи обращаемся к пользователю которому она пренадлежит и получаем объект этого пользователя, соотв можно обратиться и к полям этого пользователя например article.user.username
      redirect_back fallback_location: root_path, notice: 'User is not owner'
    end
  end
end


# 5. В aticles/index.html.erb добавим условия для сокрытия ссылок на редактирование и удаление статьи




puts
puts '                                          Rspec для Rails'

# Установка и настройка гемов

# 1. Добавить в Gemfile нашего Rails-приложения:
group :test, :development do # добавим гемы только для 2х типов окружения(test, development)
  gem 'rspec-rails'
  gem 'shoulda-matchers'   # добавляет матчеры для проверки моделей(работает как для rspec так и для обычных юнит тестов)   http://matchers.shoulda.io/docs/v3.1.3/    https://github.com/thoughtbot/shoulda-matchers
  gem 'capybara'
end
# > bundle install

# 2. Настройка Rspec для Rails:
# > rails g rspec:install   # (этот генератор, среди прочих, добавился при установке gem 'rspec-rails') запускает гем и выполняет его установку в наше приложение(установит дополнительные каталоги и хэлперы)
  # Создались:
  # .rspec                 - содержит опции/настройки(например для цветового вывода)
  # spec                   -
  # spec/spec_helper.rb
  # spec/rails_helper.rb
#      (У меня не возникла)(Проблема из комментов: когда прописал команду rails g rspec:install после стоит на месте, нужно прервать и написать так DISABLE_SPRING=true rails generate rspec:install)

# 3. Настроим Shoulda-matchers, добавив в spec/rails_helper.rb(добавил в rails_helper.rb):
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# (! Из комментов, не пользовался)Для рельсов 6.1 в Gemfile нужен gem 'rexml'
# stackoverflow.com/questions/65479863/rails-6-1-ruby-3-0-0-tests-error-as-they-cannot-load-rexml


puts
puts '                                      Rspec Тестирование моделей'

# Создадим для тестирования моделей каталог /spec/models. В нем будем создавать фаилы для тестирования моделей
# матчеры для проверки моделей(работает как для rspec так и для обычных юнит тестов) http://matchers.shoulda.io/docs/v3.1.3/    https://github.com/thoughtbot/shoulda-matchers

# Модель, которую будем тестировать (/app/models/contact.rb):
class Contact < ApplicationRecord
  validates :email, presence: true
  validates :message, presence: true
end

# Создадим тест для модели: создать файл /spec/models/contact_spec.rb
require 'rails_helper' # подключаем фаил spec/rails_helper.rb
# Далее синтакс rspec(но тут почемуто без названий тестов)
describe Contact do
  it { should validate_presence_of :email } # должно проверять присутсвие email(тестируем валидацию)
  # validate_presence_of - матчер
  it { should validate_presence_of :message }
end

# Запустим тест(Возникает ошибка):
# > rake spec     # запускаем rspec через rake, но можно и обычным способом
#   ActiveRecord::PendingMigrationError:
#     Migrations are pending. To resolve this issue, run:
#             bin/rails db:migrate RAILS_ENV=test
#     You have 6 pending migrations:
#     20230701043625_create_articles.rb
#     20230704072035_create_contacts.rb
#     20230715072256_create_comments.rb
#     20230721073907_devise_create_users.rb
#     20230725060054_add_username.rb
#     20230725065349_add_index.rb
#     ./spec/rails_helper.rb:28:in `<top (required)>'
# Это происходит потому что тестовая БД не содержит миграций, перенесем в нее миграции при помощи команды:
# > rails db:migrate RAILS_ENV=test
# И заново запустим тест
# > rake spec
#   ....
#   Finished in 0.12658 seconds (files took 8.77 seconds to load)
#   4 examples, 0 failures


# Используем другой матчер have_many http://matchers.shoulda.io/docs/v3.1.3/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method

# Создадим тест /spec/models/article_spec.rb:
require 'rails_helper'
describe Article do # сущность Article должа иметь много комментов
  it { should have_many :comments } # have а не has ииза правил английского тк есть should
end

# Создадим тест /spec/models/comment_spec.rb
require 'rails_helper'
describe Comment do
  it { should belong_to :article } # в матчере belong хотя в модели belongs
end


puts
puts '                                    Rspec Вложенный describe'

# Вложенный describe - повышает читаемость кода тестов

# Предварительно добавим в модель article.rb валидацию тк ее не было
class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments
end

# /spec/models/article_spec.rb:
require 'rails_helper'

describe Article do
  # разбиваем на логически обоснованные разделы
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :text }
  end

  describe "assotiations" do
    it { should have_many :comments }
  end
end

# Нэйминг(желательный) после describe - помогает прогам считать какое коллич кода покрыто тестами
# НЕ методы:                     describe "something" do
# instance методы:               describe "#method_name" do
# class методы (self.method):    describe ".method_name" do


puts
puts '                                             Factory Bot'

# Factory Bot - помогает при тестировании, чтобы не создавать в AR объекты для теста и тестовую БД, вместо этого создаётся фабрика, и она будет создавать нам объекты для теста. Это соотв принципу DRY тк не нужно создавать тестовую БД
# Раньше был другой гем gem Factory Girl(устарел)
# https://github.com/thoughtbot/factory_bot/blob/v4.9.0/UPGRADE_FROM_FACTORY_GIRL.md
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md


# Установка для Рэилс(Для Рэилс и без него разные подгемы и разная настройка):
# Добавить в Gemfile:
group :development, :test do
  # ... предыдущие гемы
  gem "factory_bot_rails"
end
# > bundle install

# Настройка конфигурации:
# (Попробовал оба оставил 2й)
# (Вар 1 из конспектов) добавить конфигурацию в /spec/rails_helper.rb:
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
# (Вар 2 из документации) добавьте конфигурацию в spec/support/factory_bot.rb (предварительно создав папку support):
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
# support - специальная папка для rspec откуда он подтягивает нужную фигню
# и обязательно подключить этот файл(support/factory_bot.rb) в фаиле rails_helper.rb
require 'support/factory_bot'


puts
# Создание фабрики:
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Defining_factories

# Создадим каталог с фабриками - /spec/factories

# создадим файл в котором будем создавать фабрику для article /spec/factories/articles.rb:
FactoryBot.define do # определяем фабрику
  factory :article do # фабрика article. По умолчанию будет брать модель Article и устанавливать в нее свойсва:
    # Зададим свойства и их значения, тк наши тесты будут проверять их валидацию и без них выдадут ошибки валидации
    title { "Article title" } # содержание параметра не важно можно любое
    text { "Article text" }
  end
end
# Теперь наша фабрика может создатЬ сущность Article со значениями полей title и text


puts
# Напишем тест с использованием созданной фабрики:

# Добавим метод в /app/models/article.rb
class Article < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true
  has_many :comments

  def subject # добавим метод который будем тестировать (возвращает название статьи ??)
    title
  end
end

# Добавим новый тест в /spec/models/article_spec.rb
require 'rails_helper'

describe Article do
  # ...какието describe/it

  describe "#subject" do
    it "returns the article title" do
      # arrange + act
      article = create(:article, title: 'Foo Bar') # создаем объект/сущность Article но не с помощью AR, а при помощи фабрики
      # create - метод factory_bot для создания сущности
      # :article - имя фабрики ??

      # assert
      expect(article.subject).to eq 'Foo Bar' # проверяем что метод subject возвращает указанное значение title сущности
    end
  end
end
# > rake spec
# (!!!Для Windows - нужно запускать в классической командной строке, в повершелл тесты будут выполняться 2 раза: по полному адресу и относительному, что может привести к ошибкам в некоторых тестах)


puts
# Пример посложнее:

# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md#Sequences    # Sequences (последовательности):
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md    # create_list (через поиск по странице):

# Добавим метод в модель /app/models/article.rb
class Article < ApplicationRecord
  # ... пред код ....

  # Создадим метод last_comment и протестируем его:
  def last_comment # метод возврата последнего комментария(Article.find(params[:id]).comments.last ??)
    comments.last # последний комментарий из колекции(видимо вообще всех комментов ??)
  end
end

# Создадим фабрику для создания комментариев /spec/factories/comments.rb:
FactoryBot.define do
  factory :comment do
    author { "Chuck Norris" }
    # вместо, например, body { "Kick" } напишем:
    sequence(:body) { |n| "Comment body #{n}" } # так комментарии будут создаваться разными значениями поля body, например 1й коммент "Comment body 1", 2й "Comment body 2" итд
    # sequence - метод принимает название поля и блок со значением
  end
end

# Добавим в фабрику article, чтобы возвращать статью сразу с комментариями /spec/factories/articles.rb:
FactoryBot.define do
  factory :article do
    title { "Article title" }
    text { "Article text" }

    # создаём фабрику для создания статьи с несколькими комментариями(создаем фабрику внутри блока фабрики article)
    factory :article_with_comments do
      after :create do |article, evaluator| # after - метод срабатывающий после чего либо. :create - метод(в тесте) после которого сработает after. Те после создания article в тесте. (evaluator - не обязательно)
        create_list :comment, 3, article: article # создаём список из 3-х сущностей комментариев(:comment из фабрики комментариев ??)
        # article: article - указываем тк в модели у нас коммент принадлежит статье, параметр статья созданная в тесте
      end
      # Те после создания article создаём список из 3-х комментариев
    end

  end
end

# В /spec/models/article_spec.rb создадим статью с комментариями для тестирования:
require 'rails_helper'

describe Article do
  # ... предыдущие тесты ...

  describe "#last_comment" do
    it "returns the last comment" do
      article = create(:article_with_comments) # создаём статью с 3 комментариями
      expect(article.last_comment.body).to eq "Comment body 3" # проверка: проверяем значение поля боди последнего коммента(тк у нас их 3 то и в значении будет 3)
    end
  end
end

# > rake spec


puts
# Еще примеры тестов из ДЗ46(на валидацию макс длинны полей при помощи матчера validate_length_of)
# https://matchers.shoulda.io/docs/v5.3.0/Shoulda/Matchers/ActiveModel.html#validate_length_of-instance_method

# Добавим валидацию длинны в модели /app/models/article.rb и /app/models/comment.rb
class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 }
  validates :text, presence: true, length: { maximum: 4000 }
  # ...
end
class Comment < ApplicationRecord
  validates :body, presence: true, length: { maximum: 4000 }
  # ...
end

# В /spec/models/article_spec.rb и /spec/models/comment_spec.rb добавим
# Вариант при помощи тестовой БД(хз как сделать фабрикой)
describe Article do
  # ... предыдущие тесты ...
  describe "validations" do
    # ... предыдущие тесты валидации ...
    it { should validate_length_of(:title).is_at_most(140) } # is_at_most(140) - не больше чем 140
    it { should validate_length_of(:text).is_at_most(4000) }
  end
end
describe Comment do
  # ... предыдущие тесты ...
  describe "validations" do
    it { should validate_length_of(:body).is_at_most(4000) }
  end
end


puts
puts '                        Приёмочное тестирование(Acceptance Testing). Gem Capybara'

# Проверка функциональности на соответствие требованиям. Отличие от юнит-тестов, что для этих тестов обычно существует план приёмочных работ(список требований и выполняются эти требования или нет). Юнит-тесты - проверка чтобы не сломалось.
# http://protesting.ru/testing/levels/acceptance.html

# Обычно unit и acceptance используются вместе в проектах

# unit:         describe   ->   it
# acceptance:   feature    ->   scenario

# feature -> scenario - это фишка Capybara аналог, describe it.
# feature - особенность(имеется ввиду какаято функциональность)
# scenario - сценарий(способ использования функциональности)
#   Пример: Для контактной формы существует 2 сценария:
#     а. Убедиться, что контактная форма существует.
#     б. Что мы можем эту форму заполнить и отправить

# https://www.rubydoc.info/github/teamcapybara/capybara/master    #Capybara
group :test do # уже поставлено ранее
  gem 'capybara'
end

# Примечание(из инфы по урокам): ссылка на capybara изменилась теперь: https://github.com/teamcapybara/capybara#using-capybara-with-rspec , для её настройки согласно документации нужно добавить в ваш файл rails_helper строчку (в rspec_helper для старых версий), хотя работает и без этой строки.
require 'capybara/rspec'

# https://github.com/teamcapybara/capybara#using-capybara-with-rspec   # Using Capybara with RSpec

# Как работает гем Капибара - он запускает движок браузера, посещает страницы, чтото заполняет если нужно, потом тесты проверяют это

# 2 типа тестов(просто удобный нэйминг):
# visitor_..._spec.rb - анонимный пользователь
# user_..._spec.rb - пользователь залогиненый в системе


puts
# Проведём тестирование контактной формы в учебном приложении RailsBlog.

# Создадим каталог /spec/features и создадим файл /spec/features/visitor_creates_contact_spec.rb:
require "rails_helper"
# Далее синтаксис как раньше только вместо describe->it будет feature->scenario
feature "Contact creation" do
  scenario "allows acess to contacts page" do # будем проверять наличие доступа к странице
    visit new_contacts_path # get 'contacts/new'(или это путь до экшена нью контроллера контакт ??)(можно прописать URL и вручную)
    # Капибара заходит на указанную страницу и что-то может на ней делать

    expect(page).to have_content 'Contact us' # проверяем что страница имеет какуюто строку(учитывает регистр)
    # page - переменная содержащая страницу(полностью сгенерированную вместе с layout)
  end
end
# > rake spec   (!!!Для Windows - нужно запускать в классической командной строке, в повершелл будет ошибка ниже:)
# Contact creation allows acess to contacts page
#      Failure/Error: visit new_contacts_path
#      ActionController::MissingExactTemplate:
#        ContactsController#new is missing a template for request formats: text/html


puts
puts '                                       i18n(internationalization)'

# i18n == internationalization - i далее 18 букв и последняя n. Интернационализация существует в Rails, при помощи нее можно не беспокоиться о регистрах в представлениях, а так же переводах на другие языки

# Можно создавать перевод для сайта и вызывать константы во views. Например, для русского языка можно создать /config/locales/ru.yml

# Работа с i18n (internationalization):

# 1. Открыть файл /config/locales/en.yml (в нем есть небольшая кокументация по использованию)
# 2. Создадим в фаиле /config/locales/en.yml раздел contacts:
# 3. Вызовем в представлении /app/views/contacts/new.html.erb: <h2><%= t('contacts.contact_us') %></h2>


puts
# Применение i18n в Capybara: Исправим последний тест с учётом i18n файл /spec/features/visitor_creates_contact_spec.rb:
require "rails_helper"

feature "Contact creation" do
  scenario "allows acess to contacts page" do
    visit new_contacts_path

    expect(page).to have_content I18n.t('contacts.contact_us')
  end
end
# > rake spec
# Теперь мы точно обращаемся к правильной строке вместо того чтоб смотреть что в ней там написано с каким регистом итд


puts
# Следующий тест, проверим создание самого контакта:

# Откроем страницу /app/views/contacts/new.html.erb и откроем код формы, чтобы узнать id (будем использовать в тесте):
# <input name="contact[email]" id="contact_email" type="text">
# <textarea name="contact[message]" id="contact_message"></textarea>

# Наш файл с тестом features/visitor_creates_contact_spec.rb:
require "rails_helper"

feature "Contact creation" do
  scenario "allows acess to contacts page" do
    visit new_contacts_path
    expect(page).to have_content I18n.t('contacts.contact_us')
  end

  scenario "allows a guest to create contact" do
    visit new_contacts_path
    fill_in :contact_email, with: 'foo@bar.ru' # fill_in - метод для того чтобы Капибара заполнила поле; :contact_email - значение id поля; with: 'foo@bar.ru' - то что будет записано в поле
    fill_in :contact_message, with: 'Foo Bar Baz'
    click_button 'Send message' # click_button - Капибара нажмет на кнопку с именем 'Send message'

    expect(page).to have_content 'Contacts create' # Проверяем страницу которая вернется после создания коммента(create.html.erb)
  end
end


puts
# Следующий тест: протестировать функциональность приложения залогинившись под пользователем

# 1. Сделаем сначала тест для гостя, что он может зарегистрироваться на сайте, т.е. протестируем форму регистрации.

# Создадим файл /spec/features/visitor_creates_account_spec.rb
require "rails_helper"

feature "Account Creation" do
  scenario "allows guest to create account" do
    visit new_user_registration_path # хэлпер пути к виду регистрации из карты маршрутов devise
    fill_in :user_username, with: 'FooBar'
    fill_in :user_email, with: 'foo@bar.com'
    fill_in :user_password, with: '1234567'
    fill_in :user_password_confirmation, with: '1234567'
    click_button 'Sign up'

    expect(page).to have_content I18n.t('devise.registrations.signed_up')
    # devise.registrations.signed_up  i18n взято из config/locales/devise.en.yml (заодно пример структуры)
  end
end
# > rake spec
# Всё это работает с базой данных test.sqlite3


# 2. Чтобы не зависеть от порядка исполнения тестов и не повотояться в коде, вынесем часть кода, которая будет использоваться во многих тестах, в метод sign_up
# /spec/features/visitor_creates_account_spec.rb:
require "rails_helper"

feature "Account Creation" do
  scenario "allows guest to create account" do
    sign_up
    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end
end

def sign_up
  visit new_user_registration_path
  fill_in :user_username, with: 'FooBar'
  fill_in :user_email, with: 'foo@bar.com'
  fill_in :user_password, with: '1234567'
  fill_in :user_password_confirmation, with: '1234567'
  click_button 'Sign up'
end
# Далее вынесем код метода sign_up в файл в каталоге /spec/support/session_helper.rb
# Потом в rails_helper.rb требуем этот файл то есть пишем - require 'support/session_helper'
# Ту же самую манипуляцию надо проделать с database_cleaner.


puts
# RSpec: before, after hooks
# https://relishapp.com/rspec/rspec-core/v/3-8/docs/hooks/before-and-after-hooks

# Нам надо использовать sign_up в разных тестах, и чтобы не повторяться и не писать один и тот же код, мы используем before, after hooks

# Исполняется перед каждым тестом в feature или describe:
before(:each) do
end

# Исполняется перед всеми(1 раз перед всеми) тестами в feature или describe:
before(:all) do
end


# 3. Создадим тест для проверки создания статьи залогиненым пользователем /spec/features/user_creates_article_spec.rb:




















#
