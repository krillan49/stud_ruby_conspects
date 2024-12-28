puts '                                              Содержание'

# Assets_solutions
#   Инфа про бандлы и компиляцию ассетов
#   Подключение бутстрап, если он еще не установлен при создании приложения
#   Ошибка билда yarn build на винде
#   rails assets:precompile  и возможная ошибка
#   Propshaft - особенности написания стилей например ссылок на картинку для бэкграунда

# СRUD
#   Паршалы
#   Рендер и редирект
#   Флэш сообщения
#   Редирект по ссылке якорю и хелпер dom_id

# Decorators
#   Отображение аватаров юзера при помощи Gravatar

# rescue_concern
#   logger.warn exception  - запиcать что либо, тут ошибку в журнал событий, в контроллере

# Helpers
#   Назначение вспомогательных методов контроллера хэлперами
#   Кастомный хэлпер для вывода названия страницы во вкладке.
#   Побочные/именованные yield и метод provide
#   Кастомные хэлперы для динамического меню, переданного через yield

# OneToMany
#   Привязка к сущности при ее создании у которой уже есть привязка(белонгс ту)

# Polym_assoc
#   модуль бутстрапа collapse для выпадающих форм
#   decorates_association
#   commentable.object  - извлечение сущьности из задекорированного объекта

# Tomselect
#   ajax и ассинхронный поиск
#   Форма с GET-запросом (экшен index) на ту же страницу

# Scaffolding
#   Некоторые методы AR

# CustomAutReg.rb
#   Создание хэлперов из вспомогательных методов в контроллере
#   Проверка корректности введенного имэйла в валидации
#   класс валидатор
#   Кастомные валидации

# Admin_Execel_Zip
#   Пространства имен для отдельных(продублированных) маршрутов, контроллеров, представлений
#   (.:format) обработка разных форматов в контроллере
#   гем для оптимизации запросов при заполнении БД (добавляет множество записей одним запросом)
#   Сервисные классы

# AuthRolePundit
#   в controllers/admin создадим базовый контроллер base_controller.rb от которого будут наследовать все остальные админские контроллеры

# mallers
#   Сброс пароля
#   !!! нет экшена в одном из контроллеров и все он равно работает (А где new ??) Потом проверить
#   представления для мэйлера
#   letter_opener - иммитация почтового сервиса для отправки писем, для девелопмента локально
#   Локализованные представления

# ActiveJob_ActiveStorage   (Плохо понятна последняя половина темы)
#   Sidekiq
#   redis/Memurai
#   Констрейт - класс ограничения доступа к маршрутам
#   mount - метод монтирования маршрута на основе параметров

# Bullet
#   Оптимизация запросов к БД. N+1

# Hotwire
#   опция pagy в контроллере добавляющая атрибуты в теги кнопок пагинации

# Locking
#   блок транзации для запросов(в том числе группы) в контроллере
#   обновление 1 поля через params[:item2][:title]

# deploy
#   Гем для PostgreSQL
#   Ошибка Gemfile.lock на Виндоус при деплое (3а)
#   Cron. app/workers. gem 'sidekiq-scheduler' Настройка Сайдкика в продакшене для выполнения задач типа Крон



puts '                                              Доп Гемы'

# Основные гемы для фронта в 03_Assets_solutions


# pry-rails  - для дебага в Рэилс при помощи остановки выполнения кода в некой точке
group :development, :test do
  gem 'pry-rails'
end
binding.pry # ставим это на любой позиции в коде, например в контроллере, тогда программа прерывается, когда код дойдет до этой точки и можно проверять все переменные и другой функционал в этой точке, прямо в выводе Рэилс


# draper - гем декоратор
# https://github.com/drapergem/draper
gem 'draper', '~> 4.0'
# ModelMethod_Decorators


# faker - это гем для генерации случайного текста.
# https://github.com/faker-ruby/faker
group :development, :test do
  gem 'faker', '~> 3' # актуальную версию смотрим в документации(тут версия не от 3х но не 4)
end
# Faker_seeds


# kaminari - гем для пагинации.
# https://github.com/kaminari/kaminari
gem 'kaminari', '~> 1.2'
# pagination


# pagy - гем для пагинации
# https://github.com/ddnexus/pagy
gem 'pagy', '~> 6.2'
# pagination


# blueprinter - это serialize/сериализатор, те программа которая генерирует объект json (тут из коллекции объектов Руби)
# https://github.com/procore-oss/blueprinter?ref=procore-engineering-blog
gem 'blueprinter'
# ManyToMany


# bcrypt-ruby - гем для хэширования паролей (криптографич алгоритмы)
# https://github.com/bcrypt-ruby/bcrypt-ruby
gem "bcrypt", "~> 3.1.7" # В Gemfile он есть по умолчанию просто его нужно раскомментировать
# CustomAutReg


# valid_email2 - гем умеет проверять не только корректность имэйла, но и по ДНСу может проверять существует ли такая доменная зона вообще или нет, а так же всякое другое, что можно дополнительно подключать в валидациях
# https://github.com/micke/valid_email2
gem "valid_email2"
# CustomAutReg


# rubyzip - гем который позволяет работать с архивами zip
# https://github.com/rubyzip/rubyzip
gem 'rubyzip', '~> 2'
# Admin_Exel_Zip


# caxlsx и caxlsx_rails - эти гемы могут только записывать/создавать новые Excel-фаилы(в том числе с графиками), а читать и парсить не могут
# https://github.com/caxlsx
# https://github.com/caxlsx/caxlsx
# https://github.com/caxlsx/caxlsx_rails
gem 'caxlsx', '~> 4'
gem 'caxlsx_rails', '~> 0.6'  # подгем для правильной работы с представлениями Рэилс
# Admin_Exel_Zip


# rubyXL - гем для считывания xlsx фаилов rubyXL
# https://github.com/weshatheleopard/rubyXL
gem 'rubyXL', '~> 3.4'
# Admin_Exel_Zip


# activerecord-import - гем для оптимизации запросов при заполнении БД (добавляет множество записей одним запросом)
# https://github.com/zdennis/activerecord-import
gem 'activerecord-import', '~> 1.5'
# Admin_Exel_Zip


# Pundit - позволит с помощью обычных классов Руби(политик) описывать то что могут делать пользователи в зависимости от роли
# https://www.rubydoc.info/gems/pundit
# https://github.com/varvet/pundit
gem 'pundit', '~> 2.3'
# UsersRoles


# letter_opener - гем позволяет тестировать отправку писем без почтового сервера, локально, отаправляет результат нам же в браузер
# https://github.com/ryanb/letter_opener
gem "letter_opener", group: :development
# mailers


# sidekiq - позволяет создавать задачи в фоновом режиме как для Рэилс, так и без него
# https://github.com/sidekiq/sidekiq
# https://github.com/sidekiq/sidekiq/wiki/Getting-Started
gem 'sidekiq', '~> 7'
# ActiveJob_ActiveStorage


# Devise - гем для авторизации
# https://github.com/plataformatec/devise
gem 'devise'
# Device


# rails-i18n - гем для наиболее типичных переводов, чтобы не прописывать в ручную: название месяцев, дней недели, валют, типичные ошибки валидации итд.
# https://github.com/svenfuchs/rails-i18n (переводы можно посмотреть в директории гема rails/locale)
gem 'rails-i18n', '~> 7'
# i18n


# rspec-rails и shoulda-matchers - Rspec для Rails
group :test, :development do
  gem 'rspec-rails'
  gem 'shoulda-matchers'     # добавляет матчеры для проверки моделей(работает как для rspec так и для обычных юнит тестов)   http://matchers.shoulda.io/docs/v3.1.3/    https://github.com/thoughtbot/shoulda-matchers
end
# Rspec


# Factory Bot - помогает при тестировании, чтобы не создавать в AR объекты для теста и тестовую БД
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md
group :development, :test do
  gem "factory_bot_rails"
end
# Rspec


# Capybara - для приемочного тестирования
# https://www.rubydoc.info/github/teamcapybara/capybara/master
# https://github.com/teamcapybara/capybara
group :test do
  gem 'capybara'
end
# Rspec


# database_cleaner - гем для rspec и capibara, который очищает БД перед каждым тестом
# https://github.com/teamcapybara/capybara#transactions-and-database-setup
# https://github.com/DatabaseCleaner/database_cleaner#rspec-example
group :test do
  gem 'database_cleaner'
end
# Rspec


# Bullet - библиотека для оптимизации запросов к БД, находящая неоптимальные запросы и делающая подсказки при просмотре страниц приложения в браузере
group :development do
  gem 'bullet'
end
# Bullet


# redis - гем для работы с redis или Memurai
gem "redis", "~> 4.0" # В Gemfile раскоментировался этот гем
# Hotwire


# Rubocop - специальный анализатор кода, который следит за стилем кода который мы пишем, в соответсвии с существующими соглашениями. Может сообщать о стилистических ошибках или исправлять некоторые автоматически.
# https://docs.rubocop.org/rubocop/1.59/installation.html
group :development do # добавим только для среды development
  gem 'rubocop', '~> 1.59', require: false
  # так же добавим 2 гема-расширения для Рубокопа(все расширения можно посмотреть во вкладке меню Projects в доках)
  gem 'rubocop-rails', '~> 2.22', require: false  # доп проверки для Рэилс https://github.com/rubocop/rubocop-rails
  gem 'rubocop-performance', '~> 1.19', require: false # доп проверки на производительность кода
end
# Rubocop


# pg - гем для Постгресс
gem 'pg', '~> 1.4.3'
# deploy


# sidekiq-scheduler - гем будет работать подтип Cron c бэкграунд воркером с sidekiq
gem 'sidekiq-scheduler', '~> 4'
# deploy














#
