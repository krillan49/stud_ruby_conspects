puts '                                            Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides

# > rails new some_name   -  cоздаcт новое рейлс-приложение в выбранной папке(вручную ничего делать не нужно), где последнее слово на выбор тк это имя директории приложения(например blog). Устанавливаются все необходимое для работы приложения, гемы итд. В итоге появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
# f .git
# d app   -  содержит отдельные папки views, models(папка для моделей), controllers
# d bin
# d config  -  конфигурация содержит много всякого, например: фаил boot.rb; папку enviroments с настройками для каждого из 3х видов окружения(development.rb, test.rb и production.rb); routes.rb - фаил для установки маршрутов;
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
# На Виндоус(64) по умодлчанию будет выдавать ошибку таймзон(tzinfo-data is not present. Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)), поэтому нужны манипуляции:
# 1. Изменить/подкрутить Gemfile.
  # Найти строки:
    # # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    # gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
  # И удалить подстроку: ", platforms: [:mingw, :mswin, :x64_mingw, :jruby]" из строки "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]", те останется только "gem 'tzinfo-data'
# 2. > gem uninstall tzinfo-data
# 3. > bundle install |или| > bundle update

# (!!! Далее могут быть проблемы в Виндоус, если запустить приложение в повершелл или гтбаш, тк у них проблемы с регистром(не воспринимают заглавные), потому нужно прописать вручную либо использовать классическую командную строку !!!)
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
puts '                                             rails generate'

# generate - команда для запуска генераторов с различными параметрами

# > rails generate генератор параметры_генератора
# > rails g генератор параметры_генератора

# Виды генераторов:
# controller - для генерации контроллеров(юрл и представления)
# model      - для генерации моделей и миграций
# ...


puts
puts '                                               Контроллеры'

# MVC(паттерн)  -  Model, View, Controller
# Controller - это специальный класс, который находится в своем фаиле и он обычно отвечает за работу с каким либо видом и URLом которые мы обработываем
# Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers
# Контроллеры, которые разнесены по разным фаилам содержат экшены/методы(обработчики).
# Экшен - это обработчик(get, post итд) какого-либо URL

#> rails generate controller home index  -  Создадим контроллер. Тут: rails generate - команда создания чегото; controller - говорит о том что мы будем создавать контроллер; home - название контроллера ; index - action(название метода/действия). В отладочной инфе пишет что добавилось. Мы создали:
# 1. фаил app/controllers/home_controller.rb В нем находится код:
class HomeController < ApplicationController # контроллер это класс
  def index # а действие это метод в этом классе(отвечающий за обработку запросов)
    # get-обработчик 'home/index'
  end
end
# 2. маршрут home/index
# 3. поддиректорию home и фаил index.html.erb в ней(app/views/home/index.html.erb)
# 4. так же различные тесты и хэлперы

# http://localhost:3000/home/index  -  теперь это представление можно открыть в браузере(почему то иногда не открывается до изменения маршрута в config/routes.rb) ??и тогда автоматически пропишется маршрут??


puts
puts '                               rails routes. routes.rb - прописывание маршрутов'

# https://guides.rubyonrails.org/routing.html

# > rails routes  -  эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут. Удобно смотреть к каким контроллерам что ведет, если забыл.

# (До версии Rails 6.1 необходимо использовать команду: rake routes вместо rails routes.)

# Сами маршруты хранятся в config/routes.rb там их тоже можно посмотреть и изменить.

# Пропишем маршруты. Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  # Обычно /home/index (который мы создали в разделе "Контроллеры")создаётся для главной страницы сайта(там где по умолчанию страница приветсвия, поэтому нужно поменять корневой маршрут) и прописать в нем вместо get 'home/index'
  get '/' => 'home#index'  # Обычный подход без REST, определяем маршрут вручную

  resources :articles # REST подход(делает маршрут по паттерну REST)
end
# и снова посмотрим через:
# > rails routes
# Добавит в вывод для articles:
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


puts
puts '                                       Модели(БД-ActiveRecord)'

# Создание модели(В Синатре была в app.rb), миграции, таблицы, БД:

# А. > rails g model Article title:string text:text    -   Создадим модель и миграцию: rails g(generate) - команда создания чегото; model - генератор модели, значит что создаем модель; Article - название модели(тут "Статья")(тот класс что отвечает за сущности); title:string text:text - свойства класса модели, те столбцы таблицы и типы данных для них, к которым мы будем обращаться;
# После запуска с использованием active_record будет автоматически созданы и описаны в выводе:
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


puts
puts '                                     Пошаговое создание контроллера'

# Сделаем контроллер пошагово, а не просто одной командой(rails g controller articles new)

# 1. http://localhost:3000/articles/new - выпадет ошибка Routing Error. Так же предложит информацию по Routes.
# Это происходит потому что у нас нет пока контроллера articles. Создадим контроллер:
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

# 3. http://localhost:3000/articles/new - выпадет ошибка ArticlesController#new is missing a template for request formats: text/html. Ошибка говорит о том что отсутствует шаблон(представление)
# Создадим вручную файл app/views/articles/new.html.erb

# Теперь можно добавлять в представление HTML-код. Все работает.


puts
puts '                                            Работа с представлениями'

# 1. Форма в Рэилс. Находится в articles/new.html.erb:
# 2. Добавим в app/controllers/articles_controller.rb экшен create:
class ArticlesController < ApplicationController
  def new # get '/articles/new'
    # по умолчанию возвращает new.html.erb
  end
  def create # post '/articles'
    render plain: params[:article].inspect # без render не перенаправляет если в views еще не создан вид create.html.erb.
    # render - метод для возврата данных из экшена, тк это возврат, то(в отличие от redirect_to) сохраняет данные из метода, например переменные; plain: params[:article].inspect - параметр функции; plain: - ключ хеша(обозначает что будет выведен просто текст); params[:article].inspect - значение хеша. В итоге выведет #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.

    # по умолчанию возвращает create.html.erb
  end
end

# Страницу /articles пользователь не сможет открыть вручную, тк для нее есть только POST-обработчик, но нет GET


puts
# (Тут тоже поэтапно а не полной командой)
# Сделаем страницу /contacts с формой для контактов. Чтобы на сервер и далее в БД передавались email и message из формы контактов.

# 1. > rails g controller contacts  -  Создаем новый(тут пустой) контроллер
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
# new_contacts   GET    /contacts/new(.:format)    contacts#new    (те GET-обработчик по адресу '/contacts/new') вернет нам представление new из дирректории contacts
# contacts       POST   /contacts(.:format)        contacts#create (те POST-обработчик по адресу '/contacts') вернет нам представление create из дирректории contacts

# 4. Создадим представление new.html.erb в дирректории contacts

# 5. Создаем модель и миграцию и запускаем миграцию.
# > rails g model Contact email:string message:text  -  Создадим модель Contact c 2мя свойсвами(столбцами)
# AR создал миграцию и модель:
class CreateContacts < ActiveRecord::Migration[7.0] # db/migrate/20230704072035_create_contacts.rb
  def change
    create_table :contacts do |t|
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
class Contact < ApplicationRecord # app/models/contact.rb
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
puts '                                               Запись в БД'

# Откроем /app/controllers/contacts_controller.rb и запишем код, но...
class ContactsController < ApplicationController
  def new
  end
  def create # принимает данные введенные пользователем в форму
    @contact = Contact.new(params[:contact])
    @contact.save
  end
end
# Но если больше ничего не добавлять то при нажатии кнопки формы вылезет ошибка: ActiveModel::ForbiddenAttributesError in ContactsController#create - т.к. аттрибуты(params[:contact]) запрещены - связано с безопасностью, например чтобы никто не смог передать данные в "created_at", "updated_at" или поменять пароль пользователя передав слово 'password'??. Все атрибуты изначально запрещенные и их нужно разрешить, для этого используется специальный синтаксис:
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
# Теперь мы можем добавить запись в БД через форму http://localhost:3000/contacts/new


puts
puts '                                               Валидация'

# 1. Валидацию надо добавить в /app/models/contact.rb
class Contact < ApplicationRecord
  # Синтаксис тот же самый что и в Синатре, тк это тот же самый ActiveRecord
  validates :email, presence: true
  validates :message, presence: true
end

# 2. Исправим код в методе create в контроллере /app/controllers/contacts_controller.rb:
def create
  @contact = Contact.new(contact_params)
  if @contact.valid? # это можно не писать и тут сразу написать @contact.save
    @contact.save # cущность содается(создастся и без create.html.erb тк создает до возврата вида)
    # тут автоматич возвращает create.html.erb
  else
    # а если не валидно вернем нашу форму new.html.erb(но уже на ЮРЛ /contacts) при помощи render
    render action: 'new'
    # action: - значит что возвращаем экшен(вид)
    # 'new' - имя экшена
  end
end

# 3. Теперь, если при заполнении формы будет ошибка валидаци, то форм билдер нам подскажет, автоматически обернув лэйбл неправильно заполненного поля и само поле в div-ы:
'<div class="field_with_errors"></div>'
# Оформление можно добавить любое через CSS в файле /app/assets/stylesheets/application.css

# 4. Выведем список ошибок. Вывод будет таким ["Email can't be blank", "Message can't be blank"]
# Откроем /app/views/contacts/new.html.erb и добавим туда код Вариант 1(так без ошибок будет выведен пустой массив)
# В app/controllers/contacts_controller.rb можно определить переменную:
def new
  @contact = Contact.new # пустая сущность
end
# Либо без пустой сущности записать в /app/views/contacts/new.html.erb Вариант 2


puts
puts '                                           Примеры изменения маршрутов'

# Сейчас у нашего блога при ручном заходе(GET) на http://localhost:3000/contacts выпадает Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик. Сделаем так, чтобы при GET-запросе по этому адресу(вместо contacts/new) у нас возвращался вид new.html.erb с формой.
# Логичное изменение тк у resours нет index по этому адресу

# Способ 1. Откроем /config/routes.rb и добавим код.
# Так пользователь получит вид и при GET запросе и на http://localhost:3000/contacts/new и на http://localhost:3000/contacts
Rails.application.routes.draw do
  get 'home/index'

  resources :articles

  get 'contacts' => 'contacts#new'  # добавим get 'contacts' возвращающий new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create]
end
# Чтобы пользователь получал вид и при GET запросе и на http://localhost:3000/contacts/new и на http://localhost:3000/contacts то изменим последнюю стоку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

# Способ 2. (в одну строку):
# Так пользователь получит вид при GET запросе только на http://localhost:3000/contacts
Rails.application.routes.draw do
  get 'home/index'

  resources :articles

  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути: path_names: { :new => '' } (По умолчанию был { :new => '/new' }). Те убирая путь для new, получается что он будет перенаправляться по базовому пути, а базовый путь для контроллера contacts это как раз /contacts
end


puts
puts '                                       Отличия resource и resources'

# resource и resources - эти ключевые слова отвечают за REST-маршруты(те 2 типа маршрутов) в нашем приложении. Они записываются в фаиле routes.rb в директории config

# Сравним 2 таблицы:

# (resource) singular-resources: https://guides.rubyonrails.org/routing.html#singular-resources
# HTTP Verb     Path              Controller#Action   Used for
# GET           /geocoder/new     geocoders#new       return an HTML form for creating the geocoder
# POST          /geocoder         geocoders#create    create the new geocoder
# GET           /geocoder         geocoders#show      display the one and only geocoder resource
# GET           /geocoder/edit    geocoders#edit      return an HTML form for editing the geocoder
# PATCH/PUT     /geocoder         geocoders#update    update the one and only geocoder resource
# DELETE        /geocoder         geocoders#destroy   delete the geocoder resource
# Всего 6 методов.
# Нет обращения по id соотв больше подходит для уникального, например профиля пользователя

# (resources) crud-verbs-and-actions: https://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
# HTTP Verb     Path              Controller#Action   Used for
# GET           /photos           photos#index        display a list of all photos
# GET           /photos/new       photos#new          return an HTML form for creating a new photo
# POST          /photos           photos#create       create a new photo
# GET           /photos/:id       photos#show         display a specific photo
# GET           /photos/:id/edit  photos#edit         return an HTML form for editing a photo
# PATCH/PUT     /photos/:id       photos#update       update a specific photo
# DELETE        /photos/:id       photos#destroy      delete a specific photo
# Всего 7 методов. Тк есть метод для вывода списка всех ресурсов photos#index. Соотв когда нам нужно например выводить все статьи.
# Есть обращения по id
# Используется чаще


# Еще пример:

# resource (profile) (профиль пользователя с позиции пользователя существует в единственном числе(его профиль)):
# Что можно сделать с ресурсом:
# -- показать - show(GET)
# -- создать - new(отобразить форму. GET), create(отправить форму. POST)
# -- редактировать - edit(GET), update(PUT\PATCH)
# -- удалить - destroy(DELETE)

# resources (articles) (стати в блоге и с точки зрения пользователя существуют во множественном числе):
# Что можно сделать с ресурсами:
# -- показать список(тут всех статей) - index(GET)
# -- показать - show(GET)
# -- создать - new(отобразить форму. GET), create(отправить форму. POST)
# -- редактировать - edit(GET), update(PUT\PATCH)
# -- удалить - destroy(DELETE)


puts
puts '                                    Вывод списка статей(resourses/index)'

# Заполним метод create для articles. Внесём изменения в /app/controllers/articles_controller.rb:
class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
    else
      render action: 'new'
    end
  end
  # Теперь нам надо создать представление для create. Создадим: /app/views/articles/create.html.erb
  # Добавим ссылку в /app/views/articles/create.html.erb на /articles на все статьи
  # При переходе на нее получим - Unknown action The action 'index' could not be found for ArticlesController тк нет метода GET по адресу /articles (который в resources является index)

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
puts '                              resourses/show. redirect_to PRG(Post Redirect Get)'

# При обновлениии страницы, возвращенной пост запросом, может произойти повторная отправка формы(выскакивает предуцпреждение), что может вызвать проблемы например 2йной покупки и 2йного списания денег
# PRG(Post Redirect Get) - паттерн для предотвращения двойного сабмитта. Тоесть POST-запрос вместо возврата вида совершает перенаправление на GET-запрос.
# Для этого в нашем случае добавим redirect_to @article в метод create
class ArticlesController < ApplicationController
  def new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article  # перенаправляет на GET show /article/id тогда представление create нам будет уже не нужно и можно его удалить.
      # redirect_to получает сущность из @article и делает редирект(по ее айди). Редирект происходит на стороне браузера, те новый get-запрос.
    else
      render action: 'new'
    end
  end

  # Далее добавим метод show на который редиректит create
  def show # get '/articles/id'
    @article = Article.find(params[:id]) # передаем id через params
    # по умолчанию возвращает articles/show.html.erb
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end

# Создадим представление /app/views/articles/show.html.erb


puts
puts '                          Редактирование статьи(resourses/edit, resourses/update)'

# Добавим ссылку на редактирование в articles/index.html.erb

# Добавим в /app/controllers/articles_controller.rb:
def edit #  get '/articles/id/edit'
  @article = Article.find(params[:id])
end

# Создадим вид /app/views/articles/edit.html.erb c формой для редактирования

# Добавим в контроллер /app/controllers/articles_controller.rb экшен update
def update  # post -> put '/articles/id'
  @article = Article.find(params[:id])
  if @article.update(article_params) # тут метод update вместо метода save, который сохранял при создании сущности
    redirect_to @article # перенаправление на show
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

# Пропишем маршруты в /config/routes.rb:
get 'terms' => 'pages#terms'
get 'about' => 'pages#about'

# Создадим представления /app/views/pages/terms.html.erb и /app/views/pages/about.html.erb


puts
puts '                                 Удаление статьи(resourses/destroy)'

# Чтобы удалить сущность, надо сделать 2 действия: найти сущность по id, удалить

# Можно удалать через рэилс консоль:
# irb(main):004:0> @a = Article.find(10)
# irb(main):005:0> @a.destroy


# Есть несколько способов удаления: через форму или через кнопку(тут через кнопку)

# Добавим в articles_controller.rb метод destroy:
def destroy # post -> delete '/articles/id'
  @article = Article.find(params[:id])
  @article.destroy

  redirect_to articles_path # перенаправляем на get 'articles' #index

  # по умолчанию возвращает destroy.html.erb
end

# Добавим в файл /views/articles/index.html.erb кнопку удаления статьи


















#
