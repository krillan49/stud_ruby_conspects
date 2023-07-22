puts '                                            Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides

# > rails new some_name   -  cоздаcт новое рейлс-приложение в выбранной папке(вручную ничего делать не нужно), где последнее слово на выбор это имя директории приложения(например blog). Устанавливаются все необходимое для работы приложения, гемы итд. В итоге появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
# f .git
# d app   -  содержит отдельные папки views, models(папка для моделей), controllers
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

# Виды генераторов(бывают как только от самого Рэилс так и от различных гемов):
# controller - для генерации контроллеров(юрл и представления)
# model      - для генерации моделей и миграций
# ...


puts
puts '                                               Контроллеры'

# MVC(паттерн)  -  Model, View, Controller
# Controller - это специальный класс, который находится в своем фаиле и отвечает за работу с URLом(и возвращаемыми видами для него), который обычно относится к какой-либо сущности.
# Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers
# Контроллеры, которые разнесены по разным фаилам содержат экшены/методы(обработчики).
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

# Пропишем маршрут. Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  # Обычно home#index создаётся для главной страницы сайта, поэтому нужно/можно поменять корневой маршрут и прописать в нем вместо get 'home/index'
  get '/' => 'home#index'  # Обычный подход без REST, определяем маршрут вручную
  # Тут мы направили обработчик URL get '/' в метод index контроллера home
end


puts
puts '                                       Модели(ActiveRecord)'

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

# 1. http://localhost:3000/articles/new - выпадет ошибка Routing Error. Так же предложит информацию по Routes. Это происходит потому что у нас нет пока контроллера articles. Создадим контроллер(без указания экшенов):
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

  resources :articles # REST подход(делает маршрут по паттерну REST)
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

# 2. Добавим в app/controllers/articles_controller.rb экшен create:
class ArticlesController < ApplicationController
  def new # get '/articles/new'
    # по умолчанию возвращает new.html.erb
  end
  def create # post '/articles'
    render plain: params[:article].inspect # без render не перенаправляет если в views еще не создан вид create.html.erb.
    # render - метод для возврата данных из экшена, тк это возврат, то(в отличие от redirect_to) сохраняет данные из метода, например переменные; plain: params[:article].inspect - параметр функции render; plain: - ключ хеша(обозначает что будет выведен просто текст); params[:article].inspect - значение хеша. В итоге выведет #<ActionController::Parameters {"title"=>"какойто тайтл", "text"=>"какой то текст"} permitted: false>.

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
# (те GET-обработчик по адресу '/contacts/new' вернет нам представление new из дирректории contacts)
# contacts       POST   /contacts(.:format)        contacts#create
# (те POST-обработчик по адресу '/contacts' вернет нам представление create из дирректории contacts)

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
# Но если больше ничего не добавлять то при нажатии кнопки формы вылезет ошибка: ActiveModel::ForbiddenAttributesError in ContactsController#create - т.к. аттрибуты(params[:contact]) по умолчанию запрещены - связано с безопасностью, например чтобы никто не смог передать данные в "created_at", "updated_at" или поменять пароль пользователя передав слово 'password'??. Все атрибуты изначально запрещенные и их нужно разрешить, для этого используется специальный синтаксис:
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
puts '                                           Примеры изменения маршрутов'

# Сейчас у нашего блога при ручном заходе(GET) на /contacts выпадает Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик(create). Сделаем так, чтобы при GET-запросе по адресу /contacts у нас возвращался вид new.html.erb с формой.
# У resource по этому адресу по умолчнию show.

# Откроем /config/routes.rb и добавим код:

# Способ 1.
# Так пользователь получит вид и при GET запросе и на http://localhost:3000/contacts/new и на http://localhost:3000/contacts
Rails.application.routes.draw do
  get 'home/index'

  resources :articles

  get 'contacts' => 'contacts#new'  # добавим обработку запроса get 'contacts' в экшен new
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
puts '                              resourses/show. redirect_to PRG(Post Redirect Get)'

# При обновлениии страницы, возвращенной пост запросом(тут post '/articles' articles#create), может произойти повторная отправка формы(выскакивает предупреждение), что может вызвать проблемы например 2йной покупки и 2йного списания денег
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

# Пропишем маршруты в /config/routes.rb:
get 'terms' => 'pages#terms'
get 'about' => 'pages#about'

# Создадим представления /app/views/pages/terms.html.erb и /app/views/pages/about.html.erb


puts
puts '                                 Удаление статьи(resourses/destroy)'

# Чтобы удалить сущность, нужно получить ее id, найти сущность по id, удалить

# Можно удалать через Pэилс консоль:
# irb(main):004:0> @a = Article.find(10)
# irb(main):005:0> @a.destroy


# Есть несколько способов удаления: через форму или через кнопку(тут через кнопку)

# Добавим в файл /views/articles/index.html.erb кнопку удаления статьи

# Добавим в articles_controller.rb метод destroy:
def destroy # post -> delete '/articles/id'
  @article = Article.find(params[:id]) # все что нам нужно для удаления это id
  @article.destroy

  redirect_to articles_path # перенаправляем на get '/articles' #index

  # по умолчанию возвращает destroy.html.erb
end


puts
puts '                               one-to-many. На примере добавления комментариев к статьям'

# Схема one-to-many: Article 1 - * Comment. Тоесть сущность(таблица, может быть связана со многими комментариями для нее)

# https://railsguides.net/advanced-rails-model-generators/
# https://guides.rubyonrails.org/association_basics.html
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html

# Полезная особенность генераторов, возможность указывать reference columns - делать ссылки на другие сущности
# Пример: > rails g model photo album:references


# 1. Создадим модель Comment со ссылкой на article:
# > rails g model Comment author:string body:text article:references
# тут article:references - дополнительный параметр, отвечающий за отношение между сущностями
# /models/comment.rb:
class Comment < ApplicationRecord
  belongs_to :article # модель создалась с этим. Тоесть комментарии принадлежат статье. Тоже можно добавлять вручную если в генераторе не указать article:references ??
end
# /db/migrate/12312314_create_comments.rb:
class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :body
      t.references :article, null: false, foreign_key: true # создало в миграции эту строку - связь по айди для комментов с какойто статьей, те поле для id статьи к которой относится коммент. Создает столбец article_id являющийся foreign_key к id в таблице articles.
      #Тоже можно добавлять вручную если в генераторе не указать article:references ??

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
Comment.all
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

# 3. many-to-many (* - *) - Есть статьи и теги(категории), у каждого тега есть много статей и у каждой статьи есть много тегов. для связи между ними создаётся ещё одна таблица tags_articles состоит только из 2х столбцов tag_id, article_id, тк недомтаточно 2х таблиц для реализации. В Рэилс доп таблица создается автоматически
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
# gem 'devise'

# 2. Запускаем команду
# > bundle

# > rails g    # Проверим какие у нас появились в системе новые генераторы для работы с Devise.
# Devise:
#   devise
#   devise:controllers
#   devise:install
#   devise:views
# Те у нас появился генератор Devise с 4мя опциями

# 3. Введём:
# > rails g devise:install
# Создались config/initializers/devise.rb  и  config/locales/devise.en.yml.
# Так же вывелись подсказки по настройкам, воспользуемся ими:

# 3-1. Добавим строку(если ее нет) в фаил config/environments/development.rb:
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 } # в значении наш локальный адрес

# 3-2. Проверить, что в /config/routes.rb указано(добавить если нет):
root to: "home#index"

# 3-3. Добавить(если нет) в app/views/layouts/application.html.erb  (Лэйаут нашего приложения). Нужно для флеш-сообщений(чтобы эта технология работала):
# <p class="notice"><%= notice %></p>
# <p class="alert"><%= alert %></p>

# 3-4(! Тут не делали !). Для кастомизации форм(можно сделать свои шаблоны для форм(логина, пароля итд) которые выдает гем):
# > rails g devise:views


puts
# Далее, создадим модель пользователя но при помощи генератора devise вместо model(так модель сразу создасться со всем полезными свойствами для авторизации: e-mail, зашифрованный пароль, токен для сброса пароля, индексы для таблиц итд итп):
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

# Начнем с того что заблокируем все(все экшены контроллера) даже просмотр(/articles) для неавторизированных пользователей
# Откроем /app/controllers/articles_controller.rb и добавим переэ экшенами:
# (Примечание: начиная с Rails 5 синтаксис before_filter устарел и заменён на before_action)
class ArticlesController < ApplicationController
  before_action :authenticate_user!

  # ... Экшены итд ...
end
# Теперь когда мы переходим на /articles то автоматически переходит на /users/sign_in и возвращает нам уже готовую форму для регистрации(sign up)/авторизации.
# Далее мы можем зарегистрироваться(наша сущность User сохранится в БД) и тогда получим доступ к экшенам

# Добавим ссылки входа и выхода в /app/views/layouts/application.html.erb
# Ссылка выхода по умолчанию не работала, необходимо в route.rb:
devise_for :users # после этой строки...
# написать еще маршрут:
devise_scope :user do
  get '/users/sign_out' => 'devise/sessions#destroy'
end
# + В config/initializers/devise.rb изменить значение
config.sign_out_via = :delete # было это
config.sign_out_via = :get    # изменить на это


puts
puts '                                         Авторизация, сессии'

# Аутентификация - проверка пользователя и пароля
# Авторизация - наделение определёнными правами в зависимости от роли (юзер/админ)

# Тк HTTP это протокол staytless(без состояния), потому после того как сервер возвращает на запрос пользователя данные, соединение сразу обрывается. Но тем не менее и со стороны сервера и пользователя пользователь останется залогинен в системе. Соотв технология логина не зависит от соединения.

# Работа технологии: для того чтобы авторизоваться, пользователь подключается к серверу, посылает свой логин и пароль, а сервер возвращает ему Cookie(токен). Cookie является уникальной. Cookie остается у пользователя. Далее когда от данного пользователя поступает следующий запрос, то вместе с ним посылается эта уникальная Cookie, по ней сервер определяет состояние пользователя. Когда пользователь разлогинивается эта Cookie удаляется. Тоесть куки тут это временный идентификатор пользователя.
#        Login, password
# User ------------------> Server
#      <------------------
#        Cookies (*)
# Сервер распознает Cookie с помощью криптографических алгоритмов, которые не требуют обращения к БД.
# Механизм шифрования основан на цифровой подписи. В Рэился главный секретный ключ(нужен чтобы устанавливать куки для пользователей) config.secret_key =(изначально закоменчен) находится /config/initializers/devise.rb
# (можно залогиниться автоматически не зная логина и пароля но зная куки для сайта, пока не было разлогина и если куки не привязаны к айпи адресу)


# Механизм сессий(происходит без авторизации)
# ?? в Рэилс приложении это хэш(для каждого пользователя разный)
session['key'] = 'value'
# Механизм сессий выдает Cookie пользователю при первом обращении к серверу, и затем без авторизации идёт обмен данными. Так сервер будет отличать неавторизованных пользователей, например для корзины товаров итд.
# Минус сессий в том что они иногда могут быть обнулены, например при перезапуске сервера






















#
