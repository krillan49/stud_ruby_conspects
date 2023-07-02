puts '                                            Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides

# > rails new some_name   -  cоздаcт новое рейлс-приложение в выбранной папке(вручную ничего делать не нужно), где последнее слово на выбор тк это имя приложения(например blog). Устанавливаются все необходимое для работы приложения, гемы итд. В итоге в директории где устанавливали появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
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
puts '                                  Запуск сервера и изправление ошибок винды'

# > rails s  (rails server| start rails s | start rails server) -  Запуск сервера приложения, запускаем в папке приложения, иначе просто выдаст справку по командам.

# Последовательность того как начинает работу rails-приложение, когда его запускаешь:
# boot.rb -> rails -> environment.rb(подгружается) -> development.rb или test.rb или production.rb(подгружается окружение)

# Если не запустится, установи nodejs(sudo apt-get install nodejs)
# На Виндоус по умодлчанию будет выдавать ошибку таймзон(tzinfo-data is not present. Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)), поэтому нужны манипуляции(тут для 64 версии Виндоус):
# 1. Изменить/подкрутить Gemfile.
  # Найти строки:
    # # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    # gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
  # И удалить подстроку: ", platforms: [:mingw, :mswin, :x64_mingw, :jruby]" из строки "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]", те останется только "gem 'tzinfo-data'
# 2. > gem uninstall tzinfo-data
# 3. > bundle install

# Далее запускается Рэилс-сервер(похож на сервер Синитры), среди прочего он говорит, что запускается на порту 3000(http://127.0.0.1:3000/)
# http://localhost:3000/  -  адрес для открытия рэилс приложений

# bundle update  -  обновление бандла


# Rails-приложение по умолчанию может запускаться в 3 разных типах окружения(режимах):
# 1. development - оптимизирует среду для удобства разработки, будет работать чуть медленнее.
# 2. test - для тестирования, те например вместо обычной БД тестовая БД или еще какието штуки для тестов
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
# controller - для генерации контроллеров
# model
# ...


puts
puts '                                               Контроллеры'

# MVC  -  Model, View, Controller
# Controller - это специальный класс, который находится в своем фаиле и он обычно отвечает за работу с какой либо сущностью или ЮРЛов которые мы обработываем
# Контроллеры, которые разнесены по разным фаилам содержат экшены/методы(обработчики). Вместо app.rb в Рэилс есть каталог app, который содержит контроллеры в поддиректории controllers
# Экшен - это обработчик какого-либо URL

#> rails generate controller home index  -  Создадим контроллер. Тут: rails generate - команда создания чегото; controller - говорит о том что мы будем создавать контроллер; home - название контроллера ; index - action(название метода/действия). В отладочной инфе пишет что добавилось. Мы создали:
# 1. фаил app/controllers/home_controller.rb В нем находится код:
class HomeController < ApplicationController # контроллер это класс
  def index # а действие это метод в этом классе
  end
end
# 2. маршрут и обработчик get 'home/index';
# 3. app/views/home/index.html.erb - фаил index.html.erb и поддиректорию home для него.
# 4. так же различные тесты и хэлперы

# (!!! Далее могут быть проблемы в Виндоус, если запустить приложение в повершелл или гтбаш, тк у них проблемы с регистром(не воспринимают заглавные), потому нужно прописать вручную либо использовать классическую командную строку !!!)
# https://discuss.rubyonrails.org/t/getting-started-with-rails-no-template-for-interactive-request/76162

# http://localhost:3000/home/index  -  теперь это представление можно открыть в браузере(почему то не открывается до изменения маршрута в config/routes.rb)


puts
puts '                                               Модели'

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
puts '                                   rails routes. routes.rb'

# https://guides.rubyonrails.org/routing.html

# > rails routes  -  эта команда из каталога конфигурации берёт файл config/routes.rb исполняет его и выводит нам список маршрутов - те URLы, типы запросов и к каким представлениям они ведут. Удобно смотреть к каким контроллерам что ведет, если забыл.

# Сами маршруты хранятся в config/routes.rb там их тоже можно посмотреть.

# До версии Rails 6.1 необходимо использовать команду: rake routes вместо rails routes.

# Внесём изменения в файл /config/routes.rb
Rails.application.routes.draw do
  # Обычно /home/index (который мы создали в разделе "Контроллеры")создаётся для главной страницы сайта(там где по умолчанию страница приветсвия, поэтому нужно поменять корневой маршрут) и прописать в нем вместо get 'home/index'
  get '/' => 'home#index'

  resources :articles
end
# и снова посмотрим через:
# > rails routes
# Добавит в вывод для articles:
# Prefix       Verb    URI Pattern                  Controller#Action
# articles     GET     /articles(.:format)          articles#index
# POST                 /articles(.:format)          articles#create
# new_article  GET     /articles/new(.:format)      articles#new
# edit_article GET     /articles/:id/edit(.:format) articles#edit
# article      GET     /articles/:id(.:format)      articles#show
#              PATCH   /articles/:id(.:format)      articles#update
#              PUT     /articles/:id(.:format)      articles#update
#              DELETE  /articles/:id(.:format)      articles#destroy

# Все маршруты/URL в Рэилс создаются по паттерну проектирования REST


puts
puts '                                        Пошаговое создание контроллера'

# Сделаем контроллер пошагово а не просто одной командой(rails g controller articles new)

# 1. Открыв http://localhost:3000/articles/new выпадет ошибка Routing Error. uninitialized constant ArticlesController. Так же предложит информацию по Routes, типа той что выдает rails routes.
# Это происходит потому чт нас нет пока контроллера articles который отвечает за эту сущность. Создадим контроллер:
# > rails g controller articles
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # Создался пустым, тк мы не задавали 2й параметр
end

# 2. Открыв http://localhost:3000/articles/new выпадет ошибка Unknown action The action 'new' could not be found for ArticlesController. Тк как у нас не было метода экшена в классе контроллера, далее добавим его вручную:
class ArticlesController < ApplicationController
  def new
  end
end

# 3. Открыв http://localhost:3000/articles/new выпадет ошибка ArticlesController#new is missing a template for request formats: text/html. Ошибка говорит о том что отсутствует шаблон. (представление)
# Создадим вручную файл app/views/articles/new.html.erb

# Теперь можно добавлять в представление HTML. Все работает.


puts
puts '                                            Работа с представлениями'

# Синтаксис похож на sinatra, но есть и отличия
















#
