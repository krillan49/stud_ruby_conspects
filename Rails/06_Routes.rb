# ?? Создать отдельный фаил для инфе по маршрутам, например там описать консерн для маршрутов и всякое такое ?? Так же констрейнт(класс ограничения) для маршрутов из ActiveJob_ActiveStorage => Визуальный интерфейс для отслеживания задач



puts '                                         Маршруты(routes.rb)'

# http://rusrails.ru/rails-routing             -  Rusrails: Роутинг в Rails
# https://guides.rubyonrails.org/routing.html

# Маршрут - это то что пишется в адресной строке браузера

# config/routes.rb - тут мы прописываем и изменяем маршруты, которые будут использоваться в нашем приложении. Когда приходит запрос с методом и маршрутом, то Рэилс смотрит в routes.rb, в какой контроллер и экшен его передавать для обработки

# /config/routes.rb - пропишем маршруты, те закрепим обработчики URLов за определенными экшенами определенных контроллеров:
Rails.application.routes.draw do

  # 1. Корневой маршрут

  # home#index обычно создаётся для главной страницы, поэтому можно поменять 'home/index'(создан контроллером по умочанию) на корневой маршрут:
  get '/' => 'home#index'  # определяем маршрут вручную(хардкод). Теперь экшен index контроллера home будет обрабатывать GET-запросы, которые придут с URL-адреса '/'
  get '/', to: 'home#index' # альт синтаксис тому что выше

  root "home#index", as: 'some' # альтернатива get '/' при помощи хэлпера root
  # as: 'some'  - не обязательное переименование хэлпера для URL root_path(перестает работать) в some_path (так же можно создавать хэлперы и для хардкод маршрутов вроде get '/' => 'home#index')
  root to: "home#index" # ?? хз в чем разница с тем что выше


  # 2. resources - маршруты по паттерну REST

  # Маршруты для которые будут обрабатываться контроллером ArticlesController, для работы с моделью Article
  resources :articles
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


  # 3. resource - маршруты по паттерну REST

  resource :contacts, only: [:new, :create] # resource(единственное число), мб и contact в единственном ??
  # only: [:new, :create] (или only: %i[new create]) - хэш с параметрами, тут указывает на то, что нужны маршруты только для методов new и create, отстальние 4 нам тут не нужны.
  # exсept: %i[new show] - создает все маршруты кроме указанных в параметре-массиве

  # Теперь если прверить при помощи rails routes то появилось 2 новых строки а не 6
  # new_contacts   GET    /contacts/new(.:format)    contacts#new
  # contacts       POST   /contacts(.:format)        contacts#create


  # 4. Обычный подход без REST, определяли маршрут вручную

  # resources это не более чем синтаксический сахар. Нет никакой разницы между написаннным выше и такой конструкцией:
  get '/questions', to: 'questions#index'
  get '/questions/new', to: 'questions#new'
  post '/questions', to: 'questions#create'
  get '/questions/:id/edit', to: 'questions#edit'
  # ...
  # или такой (?? адреса через хэлперы ??):
  get "semester" => "semesters#show"
  get "semesters" => "semesters#index"
  get "edit_semester" => "semesters#edit"
  get "new_semester" => "semesters#new"
  patch "semesters" => "semesters#update"
  post "semesters" => "semesters#create"


  # 5. Разное

  get '/*pages/', to: 'pages#show' # все маршруты для любого уровня вложенности чтоб их принимал один контроллер?
  # И в параметрах приходит условно { pages: 'page1/страница2/.../страница4' }
end
# Примечание: если мы прописываем несколько маршрутов URL для одного и тогоже экшена и контроллера, то он будет обрабатывать все эти маршруты


# > rails routes  -  (До версии Rails 6.1 - rake routes) эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - URLы, типы запросов и к каким представлениям они ведут.
# Так же можно смотреть маршруты в браузере введя несуществующий URL от нашего корня, либо перейти по адресу /rails/info/routes



puts '                           Контроллер и роутинг статических страниц(не по REST)'

# Статические страницы это те которые не изменяются динамически, те не содержат динамической информации и всегда отображаются одинаково ?? например просто передаются переменными из экшенов ??. Подходит например для страниц "О нас", "Контакты" итд

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



puts '                      Полный цикл создания контроллера, маршрутов, модели, видов(resourse)'

# Сделаем страницу /contacts с формой для контактов. Чтобы на сервер и далее в БД передавались email и message из формы контактов.

# 1. > rails g controller contacts  -  Создаем новый контроллер без экшенов
# Создалось: app/controllers/contacts_controller.rb и app/views/contacts
class ContactsController < ApplicationController
  # Добавим в ContactsController экшены
  def new    # получение страницы(форма с текстовыми полями) от сервера  - get (new по REST)
  end
  def create # отправка и обработка данных введенных пользователем на сервер - post (create по REST)
  end
end

# 2. Прописываем маршруты. Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  resource :contacts, only: [:new, :create] # resource(единственное число).
end



puts '                                  Пример изменения стандартных маршрутов'

# Сейчас при GET-запросе на URL /contacts выпадает Routing Error. No route matches [GET] "/contacts", потому что у этого маршрута есть только POST-обработчик(create). Сделаем так, чтобы GET '/contacts' у нас обрабатывался в экшене new, соотв возвращался вид new.html.erb с формой.(У resource по этому запросу по умолчнию show.)

# /config/routes.rb:
Rails.application.routes.draw do
  # Способ 1(хардкод):
  get 'contacts' => 'contacts#new'    # добавим обработку запроса get 'contacts' в экшен new
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
  # Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю строку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

  # Способ 2(Лучше тк меняет имя хэлпера и не будет ошибок, например с приемочными тестами):
  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути { :new => '' } (По умолчанию был {:new => '/new'} ). А базовый путь для контроллера contacts это как раз /contacts
end



puts '                                  OneToMany'

# 3. Добавим в маршруты статей через блок маршруты комментариев в /config/routes.rb:
resources :articles do # Добавим сюда блок с маршрутами комментов, те сделаем вложенный маршрут:
  resources :comments, exсept: %i[new show] # создает карту маршрутов по REST, но вложенный (одни ресурсы в других)
  # exсept: %i[new show] - создает все маршруты кроме указанных в параметре-массиве
end
# article_comments_path     GET      /articles/:article_id/comments          comments#index
# new_article_comment_path  GET      /articles/:article_id/comments/new      comments#new
#                           POST     /articles/:article_id/comments          comments#create
# article_comment_path      GET      /articles/:article_id/comments/:id      comments#show
# edit_article_comment_path GET      /articles/:article_id/comments/:id/edit comments#edit
#                           PATCH    /articles/:article_id/comments/:id      comments#update
#                           PUT      /articles/:article_id/comments/:id      comments#update
#                           DELETE   /articles/:article_id/comments/:id      comments#destroy
# Тут article_id то что в маршрутах articles являлось id, тут id это айди коммента



puts '                                 Polym_assoc'

# 3а. Пропишем маршруты для комментариев
resources :questions do
  resources :comments, only: %i[create destroy] # добавим вложенные комменты
  resources :answers, except: %i[new show] # тут не будем делать еще одно вложение для комментов, тк маршрут получится слишком длинный и сложный ...
end
# ... вместо этого придется сделать дополнительные маршруты ответов и вложить в них комменты
resources :answers, except: %i[new show] do
  resources :comments, only: %i[create destroy]
end

# 3б. Пропишем маршруты для комментариев с использованием консерна, чтобы не дублировать маршруты
Rails.application.routes.draw do
  concern :commentable do # создаем консерн маршрутов называем его :commentable (? название любое ?)
    resources :comments, only: %i[create destroy] # помещаем внутрь дублирующиеся маршруты
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resources :questions, concerns: :commentable do
      # concerns: :commentable - маршруты из консерна :commentable будут вложены в данный
      resources :answers, except: %i[new show]
    end

    resources :answers, except: %i[new show], concerns: :commentable # тут тоже вкладываем консерн
  end
end



puts '                        Tomselect_Serialize'

# Создадим новый namespace :api и в нем маршрут для тегов по которому будут передаваться введеные пользователем символы
Rails.application.routes.draw do
  # ...
  namespace :api do
    resources :tags, only: :index
  end
  # не помещвем его в скоуп с локалями, тк от локалей он зависеть не будет
end



puts '                      Namespace_Admin'

# 1. Создадим отдельные маршруты в namespace для администратора
namespace :admin do # создаем namespace с именем :admin и внутри создаем(копируем) маршруты отдельные для админа
  resources :users, only: %i[index create]
end
# Посмотрим как выглядят эти маршруты:
# admin_users_path	   GET	     /admin/users(.:format)	   admin/users#index
#                      POST	     /admin/users(.:format)	   admin/users#create
# тоесть это отдельные URLы и им нужен отдельный контроллер useres_controller.rb в поддирректоррии admin



puts '                i18n'

# 3. Настройка маршрутов для переключения языков пользоавтелем
# Задача в том чтобы адрес мог содержать как наши локали(localhost:3000/en/posts или localhost:3000/ru/posts) так и был адрес без локали, в котором будет локаль по умолчанию(localhost:3000/posts)
Rails.application.routes.draw do
  # оборачиваем блок для scope все маршруты, представления для которых будут садержать переводы:
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
    # "(:locale)" - название элемента локали в маршруте, скобки значат что локаль(например /en/) в маршруте не обязательна
    # locale: /#{I18n.available_locales.join('|')}/  - аргумет с регуляркой, который проверяет что язык в URL адресе запроса :locale исключительно из тех что мы прописали в кофиг( %i[en ru] )

    # все наши маршруты будут внутри данного блока для scope
  end
end



puts '                       mailers'

# 1. Создадим новый маршрут для контроллера сброса пароля в routes.rb
Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do

    resource :password_reset, only: %i[new create edit update]
    # resource - создаем именно ресурс, а не ресурсы, тк ни с какими id работать не будем, а только с записью юзера по имэйл
    # new create - для того чтобы запросить у пользователя инструкции для сброса пароля и отправить ему письмо
    # edit update - для того чтобы сбросить пароль
  end
end



puts '                 ActiveJob_ActiveStorage   Визуальный интерфейс для отслеживания задач. Констрейт для маршрутов'

# В routes.rb настроим маршрут для интерфейса отслеживания задач в нашем приложении, так же ограничим его только для администратора

# (Весь код далее из routes.rb)

require 'sidekiq/web' # подключаем сайдкик-веб

# Для того чтобы ограничить интерфейс только для администратора, добавим констрэйт(класс ограничения)
class AdminConstraint
  def matches?(request) # обязательно должен быть этот метод
    # request - это тот запрос, который был отправлен на маршрут (тут '/sidekiq'), он перенаправляется сюда на проверку(тк тело запроса содержит данные о сессии и куки), чтобы мы поняли от кого пришел запрос
    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id] # возьмем user_id либо из сессии, либо из зашифрованного куки если пользователь поставил галочку запомнить его
    # request.session[:user_id] - находим в теле запрса данные сессии и в них айди пользователя
    # request.cookie_jar.encrypted[:user_id] - находим в теле запрса зашифрованный куки, но просто обратиться к нему не получится, поэтому нужно дополнительно применить метод cookie_jar
    # cookie_jar - берется из модуля (?)АктивДиспатч, этот модуль доступен в маршрутах потому дешифровка куки будет автоматической
    User.find_by(id: user_id)&.admin_role? # ищем пользователя по айди и проверяем админ ли это
    # Либо пускаем этого пользователя по этому маршруту либо нет, в зависимости от того что вернет метод.
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  # mount - метод монтирует маршрут на основе параметров
  # Sidekiq::Web => '/sidekiq'  - выбираем адрес по которому в приложении будет доступен Sidekiq::Web, тоесть мы подключаем интерфейс Сайдкика по данному адресу на нашем сайте.
  # constraints: AdminConstraint.new - опция для обращения к проверке констрэйтом, чтобы разрешить этот маршрут только админу

  # ...
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    # ...
    namespace :admin, constraints: AdminConstraint.new do
      # constraints: AdminConstraint.new - можно использовать тот же ограничитель, чтоб дополнительно ограничить пространсво имен маршрутов админа
      resources :users, only: %i[index create edit update destroy]
    end
    # ...
  end
end

# Далее открываем приложение по адресу 'http://localhost:3000/sidekiq' и видем подробную статистику по задачам и действиями с ними со всякими менюшками и графиками