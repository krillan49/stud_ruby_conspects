puts '                                             REST'

# REST - паттерн для передачи состояния объекта. Это соглашение о том как лучше называть и структурровать URLы и методы их обрабатывающие. Сокращает число необходимых URL, делит методы по типу запросов, что позволяет админам распределять нагрузку тк они видят в юрл что за запрос.

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
# Всего 6 методов.
# Нет обращения по id соотв больше подходит для уникального, например профиля пользователя

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
# Всего 7 методов. Тк есть метод для вывода списка всех ресурсов articles#index. Соотв когда нам нужно например выводить все статьи.
# Есть обращения по id
# Используется чаще


puts
puts '                                        Вложенные маршруты'

# Схема one-to-many: Article 1(resourses) - * Comment(resourses). Тоесть сущность(таблица, может быть связана со многими комментариями для нее)
# article_comments     GET      /articles/:article_id/comments(.:format)          comments#index
# new_article_comment  GET      /articles/:article_id/comments/new(.:format)      comments#new
#                      POST     /articles/:article_id/comments(.:format)          comments#create
# article_comment      GET      /articles/:article_id/comments/:id(.:format)      comments#show
# edit_article_comment GET      /articles/:article_id/comments/:id/edit(.:format) comments#edit
#                      PATCH    /articles/:article_id/comments/:id(.:format)      comments#update
#                      PUT      /articles/:article_id/comments/:id(.:format)      comments#update
#                      DELETE   /articles/:article_id/comments/:id(.:format)      comments#destroy
