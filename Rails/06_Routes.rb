puts '                                         Маршруты(routes.rb)'

# http://rusrails.ru/rails-routing             -  Rusrails: Роутинг в Rails
# https://guides.rubyonrails.org/routing.html

# Маршрут - это то, что пишется в адресной строке браузера

# config/routes.rb - тут прописываются и изменяются маршруты, которые будут использоваться в приложении. Когда приходит запрос с методом и маршрутом, то Рэилс смотрит в routes.rb, в какой контроллер и экшен его передавать для обработки. Тоесть прописывая маршруты в routes.rb, соответсвенно закрепляем обработчики URLов за определенными экшенами определенных контроллеров

# > rails routes  -  (До версии Rails 6.1 - rake routes) эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит список маршрутов - URLы, типы запросов и к каким представлениям они ведут.
# Так же можно смотреть маршруты в браузере введя несуществующий URL от корня, либо перейти по адресу /rails/info/routes



puts '                                 Типы и синтаксис маршрутов в routes.rb'

# /config/routes.rb
Rails.application.routes.draw do

  # 1. Корневой маршрут

  # home#index обычно создаётся для главной страницы, поэтому можно поменять 'home/index'(создан контроллером по умочанию) на корневой маршрут:
  get '/' => 'home#index'  # определяем маршрут вручную(хардкод). Теперь экшен index контроллера home будет обрабатывать GET-запросы, которые придут с URL-адреса '/'
  get '/', to: 'home#index' # альт синтаксис тому что выше

  root "home#index", as: 'some' # альтернатива get '/' при помощи хэлпера root
  # as: 'some'  - не обязательное переименование хэлпера для URL root_path(перестает работать) в some_path (так же можно создавать хэлперы и для хардкод маршрутов вроде get '/' => 'home#index')
  root to: "home#index" # ?? хз в чем разница с тем что выше


  # 2. resources - маршруты по паттерну REST

  resources :articles # тут маршруты будут обрабатываться контроллером ArticlesController, для работы с моделью Article
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
  # Теперь если прверить при помощи rails routes то появилось 2 новых строки а не 6
  # new_contacts   GET    /contacts/new(.:format)    contacts#new
  # contacts       POST   /contacts(.:format)        contacts#create

  resource :contacts, exсept: %i[new show]
  # exсept: %i[new show] - создает все маршруты кроме указанных в параметре-массиве

  resources :tags, only: :index # можно задавать без массива, если одно значение


  # 4. Можно прописать маршруты и отдельно вручную, в том числе и REST. resources / resource - это не более чем просто синтаксический сахар. Нет никакой разницы между написаннным выше и такой конструкцией:

  get '/questions', to: 'questions#index'
  get '/questions/new', to: 'questions#new'
  post '/questions', to: 'questions#create'
  get '/questions/:id/edit', to: 'questions#edit'

  # или такой (?? адреса через хэлперы ??):
  get "semester" => "semesters#show"
  get "semesters" => "semesters#index"
  get "edit_semester" => "semesters#edit"
  get "new_semester" => "semesters#new"
  patch "semesters" => "semesters#update"
  post "semesters" => "semesters#create"


  # 5. Маршруты для статических страниц (которые не изменяются динамически с бэкенда)

  # Пропишем маршруты от корня, тк удобнее получать их от корня, а не от имени контроллера в ЮРЛ
  get 'terms' => 'pages#terms'
  get 'about' => 'pages#about', as: 'about'
  # as: 'about' - для статических тоже можно создать хэлперы юрлов, тут about_path


  # 6. Разное

  # Если мы прописываем несколько маршрутов URL для одного и тогоже экшена и контроллера, то он будет обрабатывать все эти маршруты
  resources :articles
  get 'terms' => 'articles#index'
  # Так экщен index контроллера articles будет обрабатывать запросы и get /articles и get /terms

  # Все маршруты для любого уровня вложенности чтоб их принимал один контроллер?
  get '/*pages/', to: 'pages#show'
  # И в параметрах приходит условно { pages: 'page1/страница2/.../страница4' }

end



puts '                                   Изменение стандартных маршрутов'

# /config/routes.rb:
Rails.application.routes.draw do
  # Способ 1(хардкод):
  get 'contacts' => 'contacts#new'    # добавим обработку запроса get 'contacts' в экшен new вместо show (тк у resource по этому запросу по умолчнию show)
  resource :contacts, only: [:create] # удаляем :new из [:new, :create], те удалим обработчик get 'contacts/new ' из экшена new
  # Чтобы пользователь получал вид и при GET запросе и на /contacts/new и на /contacts то изменим последнюю строку на resource :contacts, only: [:new, :create], те обратоно добавим :new в маршрут

  # Способ 2(Лучше тк меняет имя хэлпера и не будет ошибок, например с приемочными тестами):
  resource :contacts, only: [:new, :create], path_names: { :new => '' } # Перенаправление идет по базовому пути { :new => '' } (По умолчанию был {:new => '/new'} ). А базовый путь для контроллера contacts это как раз /contacts
end



puts '                                     Маршруты с локалями (i18n)'

# Можно настроить маршруты для переключения языков пользоавтелем

# Нужно чтобы адрес мог содержать существующие локали(localhost:3000/en/posts или localhost:3000/ru/posts) так и был адрес без локали, в котором будет локаль по умолчанию(localhost:3000/posts)

Rails.application.routes.draw do
  # Оборачиваются в блок для scope все те маршруты, представления для которых будут садержать переводы:
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
    # "(:locale)" - название элемента локали в маршруте, скобки значат что локаль(например /en/) в маршруте не обязательна
    # locale: /#{I18n.available_locales.join('|')}/  - аргумет с регуляркой, который проверяет что язык в URL адресе запроса :locale исключительно из тех, что мы прописали в кофиг( %i[en ru] )

    # все маршруты, представления для которых будут садержать переводы, будут внутри данного блока для scope
  end
end



puts '                                      Ассоциации One To Many'

# Добавим в маршруты комментариев(belongs_to) через блок в маршруты статей(has_many)

resources :articles do # Добавим сюда блок с маршрутами комментов, те сделаем вложенный маршрут:
  resources :comments, exсept: %i[new show] # создает карту маршрутов по REST, но вложенно (одни ресурсы в других)
end
# article_comments_path     GET      /articles/:article_id/comments          comments#index
# new_article_comment_path  GET      /articles/:article_id/comments/new      comments#new
#                           POST     /articles/:article_id/comments          comments#create
# article_comment_path      GET      /articles/:article_id/comments/:id      comments#show
# edit_article_comment_path GET      /articles/:article_id/comments/:id/edit comments#edit
#                           PATCH    /articles/:article_id/comments/:id      comments#update
#                           PUT      /articles/:article_id/comments/:id      comments#update
#                           DELETE   /articles/:article_id/comments/:id      comments#destroy



puts '                                      Полиморфные ассоциации'

# Пропишем маршруты для комментариев(belongs_to) полиморфно относящихся к вопросоам(has_many) и ответам(has_many) вложенно и в те и в другие

resources :questions do
  resources :comments, only: %i[create destroy] # добавим вложенные комменты
  resources :answers, except: %i[new show]      # тут не будем делать еще одно вложение для комментов, тк маршрут получится слишком длинный и сложный ...
end
# ... вместо этого придется сделать дополнительные маршруты ответов и вложить в них комменты
resources :answers, except: %i[new show] do
  resources :comments, only: %i[create destroy]
end



puts '                                      Консерн для маршрутов'

# concern для маршрутов помогает избежать дублирование, например вложенных маршрутов

# маршруты, для полиморфной сущности комметариев, через консерн, чтобы не дублировать их вложение:
Rails.application.routes.draw do
  concern :commentable do # создаем консерн маршрутов называем его :commentable (название любое)
    resources :comments, only: %i[create destroy] # помещаем в консерн предполагаемые дублирующимися маршруты
  end

  resources :answers, except: %i[new show], concerns: :commentable
  # concerns: :commentable - маршруты из консерна :commentable будут вложены в маршруты :answers

  resources :questions, concerns: :commentable do
    # concerns: :commentable - маршруты из консерна :commentable будут вложены в маршруты :questions
    resources :answers, except: %i[new show]
  end
end



puts '                                     Нэймспэйс для маршрутов'

# namespace - метод позволяет обернуть маршруты в нэймспэйс, чтобы иметь несколько комплектов одноименных маршрутов.

# Создадим отдельные маршруты, юзеров, в namespac-e для администратора. Это отдельные URLы и им нужен отдельный контроллер useres_controller.rb в поддирректоррии admin
Rails.application.routes.draw do
  # создаем namespace с именем :admin и внутри создаем отдельные маршруты юзеров для админа
  namespace :admin do
    resources :users, only: %i[index create edit update destroy]
  end
  # admin_users_path	   GET	     /admin/users(.:format)	   admin/users#index
  #                      POST	     /admin/users(.:format)	   admin/users#create

  # Теперь отдельные маршруты юзера для админа и для остальных пользователей могут существовать одновременно
  resources :users, only: %i[new create edit update]
end




puts '                                      Констрейт для маршрутов'

# Констрейт - класс ограничений для маршрутов, чтобы позволять использовать их только пользователям с определенными ролями, например админские маршруты только админам

# На примере ActiveJob_ActiveStorage, чтобы подключить визуальный интерфейс для отслеживания задач sidekiq и ограничить его только для администратора

# (Весь код далее из routes.rb)

require 'sidekiq/web' # подключаем сайдкик-веб

# Для того чтобы ограничить интерфейс только для администратора, добавим констрэйт(класс ограничения)
class AdminConstraint
  def matches?(request) # обязательно должен быть этот метод
    # request - это тот запрос, который был отправлен на маршрут (тут '/sidekiq'), он перенаправляется сюда на проверку(тк тело запроса содержит данные о сессии и куки), чтобы узнать от кого пришел запрос

    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id] # возьмем user_id либо из сессии, либо из зашифрованного куки
    # request.session[:user_id]              - находим в теле запрса данные сессии и в них айди пользователя
    # request.cookie_jar.encrypted[:user_id] - находим в теле запрса зашифрованный куки, но просто обратиться к нему не получится, поэтому нужно дополнительно применить метод cookie_jar
    # cookie_jar - берется из модуля (?)АктивДиспатч, этот модуль доступен в маршрутах потому дешифровка куки будет автоматической

    User.find_by(id: user_id)&.admin_role? # ищем пользователя по айди и проверяем админ ли это
    # Либо пускаем этого пользователя по этому маршруту либо нет, в зависимости от того что вернет метод.
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  # mount                            - метод монтирует маршрут на основе параметров
  # Sidekiq::Web => '/sidekiq'       - выбираем адрес по которому в приложении будет доступен Sidekiq::Web, тоесть мы подключаем интерфейс Сайдкика по данному адресу на нашем сайте.
  # constraints: AdminConstraint.new - опция для обращения к проверке констрэйтом, чтобы разрешить этот маршрут только админу

  namespace :admin, constraints: AdminConstraint.new do
    # constraints: AdminConstraint.new - можно использовать тот же ограничитель, чтоб дополнительно ограничить пространсво имен маршрутов админа
    resources :users, only: %i[index create edit update destroy]
  end
end
















#
