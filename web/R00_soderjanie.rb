puts '                                              Содержание'

# R03_Assets_solutions
#   Инфа про бандлы и компиляцию ассетов
#   Подключение бутстрап, если он еще не установлен при создании приложения
#   Ошибка билда yarn build на винде
#   rails assets:precompile  и возможная ошибка
#   Propshaft - особенности написания стилей например ссылок на картинку для бэкграунда

# R05_CRUD.rb
#   Миграции для добавления новых столбцов и изменения их свойств

# R06_filters_consern
#   before_action
#   rescue_from(обработка ошибок в контроллере)

# R09_Helpers
#   Назначение вспомогательных методов контроллера хэлперами
#   Кастомный хэлпер для вывода названия страницы во вкладке.
#   Побочные/именованные yield и метод provide
#   Кастомные хэлперы для динамического меню, переданного через yield

# R11_OneToMany
#   Методы up и down (добавление foreign_key в существующие таблицы, изменение значений по умолчанию в существующих колонках/строках)
#   Декорация при помощи метода в декораторе сущьности от ассоциации в OneToMany -> User 1 - * Some. Методы up и down -> пункт 3
#   Привязка к сущности при ее создании у которой уже есть привязка(белонгс ту)
#   Дополнительно(не относится к основной теме) вынесем повторяющийся код из экшенов контроллеров вопросов и ответов в отдельный метод нового консерна    load_question_answers(do_render: true)
#   Отображение аватаров юзера при помощи Gravatar
#   callbacks(функции обратного вызова)

# R12_Polym_assoc
#   concern для модели и маршрутов
#   модуль бутстрапа collapse для выпадающих форм
#   decorates_association

# R13_ManyToMany
#   Метод класса модели с синтаксисом scope :all_by_tags, ->(tags) do .. end
#   TomSelect, ajax и поиск
#   парсинг json(serialize) blueprinter, рендер json

# R14_Scaffolding
#   Некоторые методы AR

# R16_CustomAutReg.rb
#   Создание хэлперов из вспомогательных методов в контроллере
#   Проверка корректности введенного имэйла в валидации
#   Кастомные валидации

# R17_Admin_Execel_Zip
#   Пространства имен для отдельных(продублированных) маршрутов, контроллеров, представлений
#   (.:format) обработка разных форматов в контроллере
#   гем для оптимизации запросов при заполнении БД (добавляет множество записей одним запросом)
#   Сервисные классы

# R19_mallers
#   Сброс пароля
#   !!! нет экшена в одном из контроллеров и все он равно работает (А где new ??) Потом проверить
#   представления для мэйлера
#   letter_opener - иммитация почтового сервиса для отправки писем, для девелопмента локально

# R20_ActiveJob_ActiveStorage
#   Sidekiq
#   redis/Memurai
#   Констрейт(класс ограничения доступа) в маршрутах

# R24_Bullet
#   Оптимизация запросов к БД. N+1

# R25_Hotwire
#   опция pagy в контроллере добавляющая атрибуты в теги кнопок пагинации

# R26_Locking
#   блок транзации для запросов(в том числе группы) в контроллере
#   обновление 1 поля через params[:item2][:title]

# R28_deploy
#   Cron. app/workers. gem 'sidekiq-scheduler'


puts
puts '                                              Доп Гемы'

# Основные гемы для фронта в R03_Assets_solutions


# pry-rails  - для дебага в Рэилс при помощи остановки выполнения кода в некой точке
group :development, :test do
  gem 'pry-rails'
end
binding.pry # ставим это на любой позиции в коде, например в контроллере, тогда программа прерывается, когда код дойдет до этой точки и можно проверять все переменные и другой функционал в этой точке, прямо в выводе Рэилс


# draper - гем декоратор
# https://github.com/drapergem/draper
gem 'draper', '~> 4.0'
# R05_ModelMethod_Decorators


# faker - это гем для генерации случайного текста.
# https://github.com/faker-ruby/faker
group :development, :test do
  gem 'faker', '~> 3' # актуальную версию смотрим в документации(тут версия не от 3х но не 4)
end
# R07_Faker_seeds


# kaminari - гем для пагинации.
# https://github.com/kaminari/kaminari
gem 'kaminari', '~> 1.2'
# R08_pagination


# pagy - гем для пагинации
# https://github.com/ddnexus/pagy
gem 'pagy', '~> 6.2'
# R08_pagination


# blueprinter - это serialize/сериализатор, те программа которая генерирует объект json (тут из коллекции объектов Руби)
# https://github.com/procore-oss/blueprinter?ref=procore-engineering-blog
gem 'blueprinter'
# R13_ManyToMany


# bcrypt-ruby - гем для хэширования паролей (криптографич алгоритмы)
# https://github.com/bcrypt-ruby/bcrypt-ruby
gem "bcrypt", "~> 3.1.7" # В Gemfile он есть по умолчанию просто его нужно раскомментировать
# R16_CustomAutReg


# valid_email2 - гем умеет проверять не только корректность имэйла, но и по ДНСу может проверять существует ли такая доменная зона вообще или нет, а так же всякое другое, что можно дополнительно подключать в валидациях
# https://github.com/micke/valid_email2
gem "valid_email2"
# R16_CustomAutReg


# rubyzip - гем который позволяет работать с архивами zip
# https://github.com/rubyzip/rubyzip
gem 'rubyzip', '~> 2'
# R17_Admin_Exel_Zip


# caxlsx и caxlsx_rails - эти гемы могут только записывать/создавать новые Excel-фаилы(в том числе с графиками), а читать и парсить не могут
# https://github.com/caxlsx
# https://github.com/caxlsx/caxlsx
# https://github.com/caxlsx/caxlsx_rails
gem 'caxlsx', '~> 4'
gem 'caxlsx_rails', '~> 0.6'  # подгем для правильной работы с представлениями Рэилс
# R17_Admin_Exel_Zip


# rubyXL - гем для считывания xlsx фаилов rubyXL
# https://github.com/weshatheleopard/rubyXL
gem 'rubyXL', '~> 3.4'
# R17_Admin_Exel_Zip


# activerecord-import - гем для оптимизации запросов при заполнении БД (добавляет множество записей одним запросом)
# https://github.com/zdennis/activerecord-import
gem 'activerecord-import', '~> 1.5'
# R17_Admin_Exel_Zip


# Pundit - позволит с помощью обычных классов Руби(политик) описывать то что могут делать пользователи в зависимости от роли
# https://www.rubydoc.info/gems/pundit
# https://github.com/varvet/pundit
gem 'pundit', '~> 2.3'
# R18_UsersRoles


# letter_opener - гем позволяет тестировать отправку писем без почтового сервера, локально, отаправляет результат нам же в браузер
# https://github.com/ryanb/letter_opener
gem "letter_opener", group: :development
# R19_mailers


# sidekiq - позволяет создавать задачи в фоновом режиме как для Рэилс, так и без него
# https://github.com/sidekiq/sidekiq
# https://github.com/sidekiq/sidekiq/wiki/Getting-Started
gem 'sidekiq', '~> 7'
# R20_ActiveJob_ActiveStorage


# Devise - гем для авторизации
# https://github.com/plataformatec/devise
gem 'devise'
# R21_Device


# rails-i18n - гем для наиболее типичных переводов, чтобы не прописывать в ручную: название месяцев, дней недели, валют, типичные ошибки валидации итд.
# https://github.com/svenfuchs/rails-i18n (переводы можно посмотреть в директории гема rails/locale)
gem 'rails-i18n', '~> 7'
# R22_i18n


# rspec-rails и shoulda-matchers - Rspec для Rails
group :test, :development do
  gem 'rspec-rails'
  gem 'shoulda-matchers'     # добавляет матчеры для проверки моделей(работает как для rspec так и для обычных юнит тестов)   http://matchers.shoulda.io/docs/v3.1.3/    https://github.com/thoughtbot/shoulda-matchers
end
# R23_Rspec


# Factory Bot - помогает при тестировании, чтобы не создавать в AR объекты для теста и тестовую БД
# https://www.rubydoc.info/gems/factory_bot/file/GETTING_STARTED.md
group :development, :test do
  gem "factory_bot_rails"
end
# R23_Rspec


# Capybara - для приемочного тестирования
# https://www.rubydoc.info/github/teamcapybara/capybara/master
# https://github.com/teamcapybara/capybara
group :test do
  gem 'capybara'
end
# R23_Rspec


# database_cleaner - гем для rspec и capibara, который очищает БД перед каждым тестом
# https://github.com/teamcapybara/capybara#transactions-and-database-setup
# https://github.com/DatabaseCleaner/database_cleaner#rspec-example
group :test do
  gem 'database_cleaner'
end
# R23_Rspec


# Bullet - библиотека для оптимизации запросов к БД, находящая неоптимальные запросы и делающая подсказки при просмотре страниц приложения в браузере
group :development do
  gem 'bullet'
end
# R24_Bullet


# redis - гем для работы с redis или Memurai
gem "redis", "~> 4.0" # В Gemfile раскоментировался этот гем
# R25_Hotwire


# Rubocop - специальный анализатор кода, который следит за стилем кода который мы пишем, в соответсвии с существующими соглашениями. Может сообщать о стилистических ошибках или исправлять некоторые автоматически.
# https://docs.rubocop.org/rubocop/1.59/installation.html
group :development do # добавим только для среды development
  gem 'rubocop', '~> 1.59', require: false
  # так же добавим 2 гема-расширения для Рубокопа(все расширения можно посмотреть во вкладке меню Projects в доках)
  gem 'rubocop-rails', '~> 2.22', require: false  # доп проверки для Рэилс https://github.com/rubocop/rubocop-rails
  gem 'rubocop-performance', '~> 1.19', require: false # доп проверки на производительность кода
end
# R27_Rubocop


# pg - гем для Постгресс
gem 'pg', '~> 1.4.3'
# R28_deploy


# sidekiq-scheduler - гем будет работать подтип Cron c бэкграунд воркером с sidekiq
gem 'sidekiq-scheduler', '~> 4'
# R28_deploy














#
