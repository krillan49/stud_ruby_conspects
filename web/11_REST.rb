puts '                                             REST API'

# https://www.youtube.com/watch?v=XaTwnKLQi4A

# REST API - архитектурный стиль(не протокол как иногда ошибочно называют, тк имеет некую свободу, а протоколы строгие), который сообщает нам о том как наиболее эффективно общаться клиенту и серверу по протоколу HTTP. Тоесть набор правил о том как наиболее эффективно использовать HTTP и строить свою API так чтобы она была удобной и эффективной.

# API (application programming interface) - програмный интерфейс(а нажатие кнопочек это графический, это другое), который описывает то как с программой стоит взаимодействовать, те предоставляет способы взаимодействия с программой. Тоесть если мы пошлем такойто запрос на такойто URL, то сервер вернет нам такойто ответ - те это правила взаимодействия. Те у каждого возможного действия есть то что ожидается на вход и есть то что ожидается на выходе.

# REST API использует концепции:
# Клиент-сервер
# Многоуровневость или многослойность системы(распределение, просирование, микросервисы итд итп)
# stateless - отсутствие состояния
# Единообразный, унифицированный интерфейс - тоесть для каждой CRUD-операции мы используем семантически правильный HTTP-метод и определенный URL(например для того чтобы выдать инфу о продукте get 'products/id' и о клиенте get 'clients/id'). Так же сюда относится принятый формат взаимодействия(json/xml итд), унифицированные названия для например токенов итд
# Кэширование, как засчет заголовков HTTP, так и сторонними штуками, например Рэдис(GET и POST запрсы могут кэшироваться, а PUT и DELETE не кэшируются). Например какието редко изменяемые данные(например список валют) при множестве запросов логичнее не каждый раз брать с сервера, а кэшировать и хранить прямо в браузере, либо при помощи сторонних кэшей на сервере(Рэдис). Это увеличивает скорость и снижает нагрузку на сервер

# формат обмена данными с REST API:
# В принципе может быть любым, но чаще всего это json и иногда xml

# REST API версионирование:
# Если мы меняем API-функционал на обратно-несовместимый, например удаляем метод DELETE для какойто сущности, то необходимо менять версию, чтобы старые пользователи так и работали со старым API, а новые пользователи(или те кто сами хотят перейти) начинают использовать новую версию

# Так же важна докумментация для API(Open API и Swagger)
# Open API - спецификация для того чтобы задокументировать API
# Swagger - набор инструментов использующий спецификацию Open API


puts
puts '                                               REST Rails'

# REST - паттерн для передачи состояния объекта. Это соглашение о том как лучше называть и структурровать URLы и методы их обрабатывающие. Сокращает число необходимых URL, делит методы по типу запросов, что позволяет админам распределять нагрузку тк они видят в URL что это за запрос.

# В REST существует 7 различных методов с помощью которых можно управлять объектами: index, show, new, create, edit, update, destroy.


puts
puts '                                       Отличия resource и resources'

# resource и resources - эти ключевые слова отвечают за REST-маршруты(те 2 типа маршрутов) в нашем приложении. Они записываются в фаиле routes.rb в директории config

# (resource) singular-resources: https://guides.rubyonrails.org/routing.html#singular-resources
# профиль пользователя с позиции пользователя существует в единственном числе(его профиль)
# ---------------------------------------------------------------------------------------------------------
# HTTP Verb     Path                Controller#Action     Что можно сделать с ресурсом:
# ---------------------------------------------------------------------------------------------------------
# GET           /profile/new        profiles#new          return an HTML form for creating the profile
# POST          /profile            profiles#create       create the new profile
# GET           /profile            profiles#show         display the one and only profile resource
# GET           /profile/edit       profiles#edit         return an HTML form for editing the profile
# PATCH/PUT     /profile            profiles#update       update the one and only profile resource
# DELETE        /profile            profiles#destroy      delete the profile resource
# ---------------------------------------------------------------------------------------------------------
# 6 методов.
# Нет обращения по id

# (resources) crud-verbs-and-actions: https://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
# статьи в блоге и с точки зрения пользователя существуют во множественном числе
# ---------------------------------------------------------------------------------------------------------
# HTTP Verb     Path                Controller#Action     Что можно сделать с ресурсами:
# ---------------------------------------------------------------------------------------------------------
# GET           /articles           articles#index        display a list of all articles
# GET           /articles/new       articles#new          return an HTML form for creating a new article
# POST          /articles           articles#create       create a new article
# GET           /articles/:id       articles#show         display a specific article
# GET           /articles/:id/edit  articles#edit         return an HTML form for editing a article
# PATCH/PUT     /articles/:id       articles#update       update a specific article
# DELETE        /articles/:id       articles#destroy      delete a specific article
# ---------------------------------------------------------------------------------------------------------
# Всего 7 методов. Тк есть метод для вывода списка всех ресурсов(статей) articles#index.
# Есть обращения по id


puts
puts '                                        Вложенные маршруты'

# Схема one-to-many: Article 1(resourses) - * Comment(resourses).
# Кадлая статья имеет много комментариев. Тоесть к каждой сущностьи статьи относится много сущностей комментов(принадлежат ей)
# ---------------------------------------------------------------------------------------------------------
# Хэлпер для URL       HTTP     Path                                      Controller#Action
# ---------------------------------------------------------------------------------------------------------
# article_comments     GET      /articles/:article_id/comments            comments#index
# new_article_comment  GET      /articles/:article_id/comments/new        comments#new
#                      POST     /articles/:article_id/comments            comments#create
# article_comment      GET      /articles/:article_id/comments/:id        comments#show
# edit_article_comment GET      /articles/:article_id/comments/:id/edit   comments#edit
#                      PATCH    /articles/:article_id/comments/:id        comments#update
#                      PUT      /articles/:article_id/comments/:id        comments#update
#                      DELETE   /articles/:article_id/comments/:id        comments#destroy











#
