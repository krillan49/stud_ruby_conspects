puts '                                            Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides

# Rails-приложение по умолчанию может запускаться в 3 разных типах окружения(режимах):
# 1. development - оптимизирует среду для удобства разработки, будет работать чуть медленнее.
# 2. test - для тестирования, те например вместо обычной БД тестовая БД или еще какието штуки для тестов
# 3. production - запускает только то что нужно для работы приложения, работает максимально быстро

# > rails new some_name   -  cоздаnm новое рейлс-приложение, где последнее слово на выбор тк это имя приложения(например blog). Устанавливает все необходимое для работы приложения, гемы итд. В итоге в директории где устанавливали появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
# f .git
# d abb   -  содержит отдельные папки views, models(папка для моделей), controllers
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

# Последовательность того как начинает работу rails-приложение, когда его запускаешь:
# boot.rb -> rails -> environment.rb(подгружается) -> development.rb или test.rb или production.rb(подгружается окружение)


puts
# > rails s  (rails server| start rails s | start rails server) -  Запуск приложения, запускаем в папке приложения, иначе просто выдаст справку по командам.
# Если не запустится, установи nodejs(sudo apt-get install nodejs)
# На Виндоус по умодлчанию будет выдавать ошибку таймзон(tzinfo-data is not present. Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)), поэтому нужны манипуляции(тут для 64 версии Виндоус):
# 1. Изменить/подкрутить Gemfile.
  # Найти строки:
    # # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
    # gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
  # И удалить подстроку: ", platforms: [:mingw, :mswin, :x64_mingw, :jruby]" из мтроки "gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]", те останется только "gem 'tzinfo-data'
# 2. > gem uninstall tzinfo-data
# 3. > bundle install

# Далее запускается Рэилс-сервер(похож на сервер Синитры), среди прочего он говорит, что запускается на порту 3000(http://127.0.0.1:3000/)
# http://localhost:3000/  -  адрес для открытия рэилс приложений

# bundle update  -  обновление бандла


puts
# MVC  -  Model, View, Controller
# Controller - отвечает за работу с какой-либо сущностью, это специальный класс, который находится в своем фаиле и он обычно отвечает за работу с какой либо сущностью или ЮРЛов которые мы обработываем

# > rails generate controller home index  -  Создадим контроллер. Тут: rails generate - команда создания чегото; controller - говорит о том что мы будем создавать контроллер; home - ; index - имя действия. В отладочной инфе пишет что добавилось. Мы создали:
# 1. фаил app/controllers/home_controller.rb В нем находится код:
class HomeController < ApplicationController # контроллер это класс
  def index # а действие это метод в этом классе
  end
end
# 2. обработчик get 'home/index';
# 3. app/views/home/index.html.erb - фаил index.html.erb и поддиректорию для него home.

# (!!! Далее могут быть проблемы в Виндоус, если запустить приложение в повершелл или гтбаш, тк у них проблемы с регистром(не воспринимают заглавные), потому нужно прописать вручную либо использовать классическую командную строку !!!)
# https://discuss.rubyonrails.org/t/getting-started-with-rails-no-template-for-interactive-request/76162

# http://localhost:3000/home/index  -  теперь это представление можно открыть в браузере

# Обычно /home/index создаётся для главной страницы сайта(там где по умолчанию страница приветсвия, поэтому нужно поменять корневой маршрут)
# Надо открыть /config/routes.rb
Rails.application.routes.draw do
  # И прописать в нем вместо get 'home/index'
  get '/' => 'home#index'
end







#
