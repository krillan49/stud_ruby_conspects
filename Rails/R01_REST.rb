puts '                                             REST API'

# https://www.youtube.com/watch?v=XaTwnKLQi4A

# REST API - архитектурный стиль(не протокол как иногда ошибочно называют, тк имеет некую свободу, а протоколы строгие), который сообщает нам о том как наиболее эффективно общаться клиенту и серверу по протоколу HTTP. Тоесть набор правил о том как наиболее эффективно использовать HTTP и строить свою API так чтобы она была удобной и эффективной.

# API (application programming interface) - програмный интерфейс(а нажатие кнопочек это графический, это другое), который описывает то как с программой стоит взаимодействовать, те предоставляет способы/правила взаимодействия с программой(если мы пошлем такойто запрос на такойто URL, то сервер вернет нам такойто ответ). Те у каждого возможного действия есть то что ожидается на вход и есть то что ожидается на выходе.

# REST API использует концепции:
# 1. Клиент-сервер
# 2. Многоуровневость или многослойность системы(распределение, просирование, микросервисы итд итп)
# 3. stateless - отсутствие состояния
# 4. Единообразный, унифицированный интерфейс - тоесть для каждой CRUD-операции мы используем семантически правильный HTTP-метод и определенный URL(например для инфы о продукте - get 'products/id', а о клиенте - get 'clients/id'). Так же сюда относится принятый формат взаимодействия(json/xml итд), унифицированные названия(например для токенов)
# 5. Кэширование, как засчет заголовков HTTP, так и сторонними решениями, например Redis(GET и POST запрсы могут кэшироваться, а PUT и DELETE не кэшируются). Например какието редко изменяемые данные(например список валют) при множестве запросов логичнее не каждый раз брать с сервера, а кэшировать и хранить прямо в браузере, либо при помощи сторонних кэшей на сервере(Рэдис). Это увеличивает скорость и снижает нагрузку на сервер

# Формат обмена данными с REST API может быть любым, но чаще всего это json и иногда xml

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
# HTTP Verb     Path                Controller#Action     Хэлпер для URL
# ---------------------------------------------------------------------------------------------------------
# GET           /profile/new        profiles#new          new_profile_path
# POST          /profile            profiles#create
# GET           /profile            profiles#show         profile_path
# GET           /profile/edit       profiles#edit         edit_profile_path
# PATCH/PUT     /profile            profiles#update
# DELETE        /profile            profiles#destroy
# ---------------------------------------------------------------------------------------------------------
# 6 методов.
# Нет обращения по id


# (resources) crud-verbs-and-actions: https://guides.rubyonrails.org/routing.html#crud-verbs-and-actions
# статьи в блоге и с точки зрения пользователя существуют во множественном числе
# ---------------------------------------------------------------------------------------------------------
# HTTP Verb     Path                Controller#Action     Что можно сделать с ресурсами:
# ---------------------------------------------------------------------------------------------------------
# GET           /articles           articles#index        articles_path
# GET           /articles/new       articles#new          new_article_path
# POST          /articles           articles#create       articles_path
# GET           /articles/:id       articles#show         article_path(:id)
# GET           /articles/:id/edit  articles#edit         edit_article_path(:id)
# PATCH/PUT     /articles/:id       articles#update       article_path(:id)
# DELETE        /articles/:id       articles#destroy      article_path(:id)
# ---------------------------------------------------------------------------------------------------------
# Всего 7 методов. Тк есть метод для вывода списка всех ресурсов(статей) articles#index.
# Есть обращения по id


puts
puts '                                        Вложенные маршруты'

# Схема one-to-many: Article 1(resourses) - * Comment(resourses).
# Каждая статья имеет много комментариев. Тоесть к каждой сущностьи статьи относится много сущностей комментов(принадлежат ей)
# ---------------------------------------------------------------------------------------------------------
# HTTP     Path                                      Controller#Action   Хэлпер для URL
# ---------------------------------------------------------------------------------------------------------
# GET      /articles/:article_id/comments            comments#index      article_comments
# GET      /articles/:article_id/comments/new        comments#new        new_article_comment
# POST     /articles/:article_id/comments            comments#create
# GET      /articles/:article_id/comments/:id        comments#show       article_comment
# GET      /articles/:article_id/comments/:id/edit   comments#edit       edit_article_comment
# PATCH    /articles/:article_id/comments/:id        comments#update
# PUT      /articles/:article_id/comments/:id        comments#update
# DELETE   /articles/:article_id/comments/:id        comments#destroy











#
