puts '                                          Deploy. Хостинг'

# deploy - развертывать (деплоить на хостинг) это процесс публикации приложения на удаленный сервер

# Выкладыванием проекта в продакшен занимается DevOps

# Рубикод на сервере будет тот же, что и локально, но окружение (базы данных, опции/параметры/настройки, веб сервер итд) другим

# ?? Как лучше заполнить БД начальными данными ??  -  надо либо делать бэкап локально и его накатывать на сервере, либо писать скрипт в seeds.rb и там описывать заполнение

# Перед деплоем в Гемфаил нужно убедиться что все гемы в нужных группах окружений, например sqlite может быть нужен только для девелопмент и тест



puts '                       Особенности хостинга проекта резрабатывавшегося на Wíndows'

# 1. Gemfile.lock - удостоверимся что прописана правильная платформа Линукс, тк без нее на сервере гемы не встанут, тк сервер всегда на Линукс
"PLATFORMS
  x64-mingw-ucrt
  x86_64-linux"     # дописываем эту строку если ее нет



puts '                                           Хостинг Heroku'

# https://www.heroku.com/

# https://github.com/krdprog/prog-conspects/blob/master/hartl-rails.md  -  инструкция развёртывания на Heroku(?? Больше нет бесплатных тарифных планов)

# https://www.youtube.com/watch?v=R4LNZSshzqE  - (10-50) пошаговыя инструкция развертывания через гит репозиторий на Хероку

# https://www.youtube.com/watch?v=Ojaxl1UhQZI&list=PL87kYOx0cUgh_2FH8flx11o0mbN9vNMIj   -  (39-50)

# https://www.youtube.com/watch?v=BqzjEI0cJGI    - (11-10)
# https://www.youtube.com/watch?v=c73OhD1Kiw4


# Heroku - облачная Paas-платформа, поддерживает ряд языков программирования (изначально поддкрживала только Руби). На ее серверах используюются ОС Debian или Ubuntu. На нее можно просто одной командой залить код и она сама поймет что там нужно равернуть, чего куда установить итд


# Самое простое для Убунту работать не через графический веб интерфейс, а через утилиту cli, которую можно установить по инструкции на сайте Хероку

# $ heroku -v                   - версия утилиты cli

# $ heroku login                - авторизоваться. Предложит открыть окошко в браузере где мы уже авторизованы, там нажимаем кнопку "login" и так авторизует нас в ОС и мы сможем работать через консоль

# Перед деплоем на хероку нужно переключить БД на PostgreSQL, тоесть в Гемфаиле sqlite вынесем в группу девелопмент и тест, а PostgreSQL добавим в группу продакшен


# Собственно хостим (из папки проекта):
# $ heroku create app_name           - выдаст нам адрес специального поддомена на который мы и сможем задеплоить, кроме того она пропишет нам локально путь к удаленному репозиторию heroku для нашего приложения. app_name - имя нашего приложения (? не обязательно ?)

# $ git remote show heroku           - посмотреть подключения к удаленному репозиторию Хероку

# $ git push heroku master           - заливаем проект с локальной машины на наш удаленный репозиторий heroku. Хероку так настроен, что как только мы делаем пуш, то приложение автоматически захостится, установит все гемы итд (хотя могут быть всякие ошибки, какие-то придется решить)

# $ heroku run rake db:migrate       - запускаем миграции на задеплоином проекте на сервере heroku

# $ heroku open                      - открыть наш сайт (тоже что и просто открыть по адресу)


# Как выкатить новую фичу (новый код добавнный в приложение локально) в работающий продакшен на Хероку - просто заккоммитить новую фичу и зпушить на хероку и она будет интегрирована и работать на сервере
# $ git push heroku master
# $ heroku run rake db:migrate          - надо только если создавали новые модели и/или миграции


# Дебаг:

# $ heroku logs --tail         - посмотреть логи нашего приложения работающего на сервере Хероку. --tail - позволяет смотреть логи в реальном времени, чтоб например чтото сделать через браузер и проверить. Выход как и обычно ctrl+c. Через графический интерфейс Хероку можнл добавить доп плагины себе для логов (но они не все бесплатные)

# $ heroku run rails c         - вызвать консоль Рэилс на удаленном сервере. Нужно быть осторожным тк эта консоль работает с реальными данными в нашем продакшене, тоесть можно изменить или удалить какие-то данные. Можно через нее, например каких-то юзеров сделать админами



puts '                                           Хостинг Render'

# https://dashboard.render.com/

# https://www.youtube.com/watch?v=cghgC5LqWoE&list=PLWlFXymvoaJ_IY53-NQKwLCkR-KkZ_44-&index=31     - урок (!!! Перепройти еще раз после прохождения гема для Постгрэ !!!)

# Render - хостинг, который предоставляет услугу PaaS (platform as a service). Позволяет быстро и легко развернуть своё приложение, ничего при этом не платя.

# ?? Cвой yarn у них автоматически 1.22.19, тоесть 1-й (не точно). Потому если использова другой может быть конфликт

# ?? Карта все равно будет нужна. Лучше какой-то российский сервис из похожих. Как пример - Amvera Cloud



puts '                                     Деплой Rails + Sidekiq на Render'

# Сделаем деплой приложения Rails, с настройкой для: БД Postgres, Redis, обработкой фоновых задач с Sidekiq и реализовав выполнение регулярных периодических задач (по типу Cron):


# 1. Создание PostgreSQL БД
# 'NEW+' => 'PostgreSQL' => Страница настроек
# Из настроек обязательно выбираем: имя, регион(лучше Франкфурт тк ближе) и тарифный план.
# Далее в панели 'Dashboard' можно посмотреть информацию о созданной БД(создается какое-то время)
# 'Internal Database URL' - понадобится потом, находится в панели 'Dashboard', в инфе данной БД (это лучше никому не показывать)


# 2. Создание Redis БД (например для экшен кейбл, турбостримов или Сайдкик)
# 'NEW+' => 'Redis' => Страница настроек
# Из настроек обязательно выбираем: имя, регион, а так же настройку 'Maxmemory Policy' - просто для кэша подойдет и 'allkeys-lru'(recommended for caches), а если юзаем задачи в очередях, Сайдкик, турбостримы, экшенкэйбл то лучше 'noeviction'(recommended for queues/persistence), тк не будет удалать старые задачи.
# В бесплатном тарифном плане всего 50 подключений, что очень мало, тк например экшенкэйбл тратит 1 подключение на 1 юзера
# Далее в панели 'Dashboard' можно посмотреть информацию о созданной БД(создается какое-то время)
# 'Internal Redis URL' - понадобится потом, находится в панели 'Dashboard', в инфе данной БД (это лучше никому не показывать)


# 3a. Конфигурация нашего приложения:
# а. Gemfile - должен быть гем именно для PostgreSQL(как минимум в группе продакшен), а не Скюлайт3
gem 'pg', '~> 1.4.3'
# б. config/database.yml - удостоверимся что в дефолтных настройках адаптера стоит 'postgresql'
'default: &default
  adapter: postgresql'
# а в настройках продакшена URL(к БД) должен браться из переменной среды ENV['DATABASE_URL'], которую мы зададим на хостинге
"production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>"
# в. config/puma.rb - удостовериться, что есть/раскомментированы настройки:
workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!
# г. config/envirnoments/production.rb - ищем строку:
config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? # и добавляем в нее  || ENV['RENDER'].present?:
config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?

# 3b. bin/render-build.sh - создадим в приложении этот Shell-скрипт, который будет использоваться для билда на хостинге (код там). Там пропишем последовательность команд, которые нужно выполнить чтобы приложение было готово к запуску.
# Далее откроем командную строку и выполним команду, чтобы установить правильные права доступа для этого фаила, чтоб его можно было выполнить:
# > chmod a+x bin/render-build.sh

# 3c. Создаем репозитарий(если его нет) с нашмим проектом на Гитхаб/Гитлаб, тк Рендер будет забирать проект из репозитармя(можно и открытый и закрытый)

# 3d. Собственно создаем новый вебсервис на Рендер
# 'NEW+' => 'Web Servise' => 'Build and deploy from a Git repository' => 'Next' => 'Connect Repository' => конектимся к нужному репозиторию(инсталируем Гитхаб или Гилаб если еще не было) => Страница настроек
# В настройках выбираем: название и регион; 'The runtime for your web service'(среду выполения) - Ruby; ветку в репозитарии; 'Build Command' - можно оставить то что было по умолчанию, но лучше используем наш Shell-скрипт bin/render-build.sh - те пропишем в поле команду - ./bin/render-build.sh; 'Start Command' - можно по умолчанию; тариф;
# Так же в самом низу нужно будет добавить переменные среды:
# REDIS_URL        - значение 'Internal Redis URL' из нашей БД Redis
# DATABASE_URL     - значение 'Internal Database URL' из нашей БД PostgreSQL
# RAILS_MASTER_KEY - генерируется при создании приложения, берем его из фаила config/master.key (тоже не нужно ни с кем делиться)

# 3e. В панели 'Dashboard' можно посмотреть информацию о созданном приложении. В Меню данного веб сервиса есть:
# Адрес нашего сайта - (сверху слева в шапке сайта под его названием)
# Events             - (в панели сбоку) - будет инфа о деплое, если делаем пуши в репозитарий, то тут тоже об этом будет инфа
# Manual Deploy      - (кнопка сверху)  - чтобы деплоить новые коммиты руками
# Logs               - (в панели сбоку) - это как консоль, тоесть и процесс установки и инфа о запросах и работе сервера
# Enviroment         - (в панели сбоку) - можем добавлять/удалять/изменять переменные среды
# Metrics            - (в панели сбоку) - разная статка
# Settings           - (в панели сбоку) - можно менять тарифный план, настраивать приложение, менять команду билда, а так же добавлять кастомные домены. А так же в самом низу кнопки выключения и удаления этого вебсервиса


# 4. (! Не бывает бесплатным) Для фоновых задач нам нужно будет создать бэкграунд воркер
# 'NEW+' => 'Background Worker' => Аналогично веб сервису выбираем нужный репозитарий => Страница настроек
# Все настройки теже, только для 'Build Command' можно просто вписать 'bundle install' тк для фоновых задач особо ничего не нужно типа эссетов итд; в 'Start Command' если мы например используем Сайдкик то так и можно вписать 'bundle exec sidekiq'
# Так же в самом низу нужно будет добавить переменные среды
# REDIS_URL        - значение 'Internal Redis URL' из нашей БД Redis
# RAILS_MASTER_KEY - генерируется при создании приложения, берем его из фаила config/master.key


# 5. Задачи типа Cron - это те задачи которые выполняются на регулярной основе например каждый день в определенное время. Можно было бы для них использовать 'NEW+'=>'Cron Job'. Но за это нужно дополнительно платить и если уже создали бэкграунд воркер с sidekiq то можно просто добавить специальный гем который это заменит и будет работать подтип Cron:
gem 'sidekiq-scheduler', '~> 4'
# app/workers/clean_worker.rb      - создадим наш воркер и директорию для него (код там)
# config/sidekiq_cron_schedule.yml - создадим данный фаил для нашего гема (код там)
# config/initializers/sidekiq.rb   - создадим фаил (код там)



puts '                                     Деплой с гемом capistrano'

# https://www.youtube.com/watch?v=xg-oB5kzTMY   - Capistrano деплой — настройка (часть 1) (Рэилс с постресс)
# https://www.youtube.com/watch?v=zvXyHR085a8   - Деплой Rails с помощью Capistrano (часть 2)

# https://github.com/capistrano/capistrano

# capistrano - гем для деплоя, популярный(?в прошлом?) для Рэилс приложений (но можно деплоить приложения на любых языках). Он имитирует работу польтзователя(Тоесть для VPS серера нет разницы зашел по SSH пользователь или capistrano), он нужен чтобы зайти на удаленную машину и выполнить ряд задач (по умолчанию уже установлен ряд задач которые подойдут для типичного Рэилс проекта)














#
