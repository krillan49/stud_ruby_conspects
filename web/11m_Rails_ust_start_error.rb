puts '                                             Rails'

# http://guides.rubyonrails.org/routing.html  -  Rails Routing from the Outside In — Ruby on Rails Guides
# http://rusrails.ru/command-line             -  Rusrails: Командная строка Rails

# https://gorails.com/setup/ubuntu/21.04      -  Хороший гайд по установке Ruby/Rails на разные ОС
# https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-18-04   - Установка Ruby/Rails на Ubuntu


# Для работы c Rails предварительно нужно установить:
# Ruby
# SQL-СУБД(например SQLite3)
# Node.js
# Yarn


# 1. Установка для виндоус:

# https://www.youtube.com/watch?v=6_ek4hokiak  - установка и настройка для Рэилс 6
# https://www.youtube.com/watch?v=tqSkBmODHBk  - установка и настройка для Рэилс 7
# (Установка: Ruby, RVM(линукс), Ruby на Windows, SQLite 3, переменных среды на Windows, NodeJS и небольшая ремарка о node-gyp, Yarn и проверка, Обновление подсистемы RubyGems, Ruby on Rails)

# https://rubyinstaller.org/downloads/   -  Устанавливаем Руби, версия с WITH DEVKIT, выделенная жирным. Во время установки ставим все галочки(разве что можно не ставить галочку документации во втором окне). Ставим галочку run reader install, затем в открывшемся терминале по очереди вводим все(хотя 2ю не обязательно) предложенные цифры + энтер(по очереди)

# https://www.sqlite.org/index.html     - Устанавливаем SQLite3. download -> sqlite-dll-win64-x64-3430200.zip там лежит фаил dll, его нужно положить в любую директорию, которая видна в переменной среды Path
# > sqlite3 --version

# https://nodejs.org/en   - Устанавливаем Node.js. Качаем LTS-версию, тоесть стабильную.
# В процессе установки обязательно поставить галочку на пункте "Установить пакетный менеджер NPM"(позволяет устанавливать сторонние библиотеки)
# желательно поставить галочку на "Хотите ли вы доставить дополнительные компоненты для компилирования библиотек"(инструменты для компиляцмм библиотек, тк некоторые библиотеки нужно компилировать). Если галка не была поставлена, то нужно воспользоваться руководством тут https://github.com/nodejs/node-gyp  Говорит что нужно установить дополнительно
# > node --version

# https://yarnpkg.com/getting-started/install   - Установить пакетный менеджер Yarn. Если уже стоит Node.js, то достаточно воспользлваться командой:
# > corepack enable        - обязательно нужно вводить в консоли от имени администратора
# Инструкции по обновлению там же в разделе миграций(не делал)
# > yarn -v               - работает только в классической командной строке
# (https://www.youtube.com/watch?v=tqSkBmODHBk  17-16  - исправление ошибок с yarn версиями 2 или 3)

# Команды апгрэйда yarn(переодически используются для собственно апгрэйда):
# > yarn upgrade                   - для версий 1.
# > yarn upgrade-interactive       - для версий 2. и 3.
# > yarn plugin interactive-tools  - если предыдущая команда выдала херню, то запустить это(добавит плагин) и потом снова пред команду

# gem update --system    - обновление подсистемы rubygems(помогает избежать некоторых ошибок)

# gem install rails  - собственно устанавливаем Рэилс
# > rails -v    # посмотреть версию рэилс



# 2. Установка Руби через RVM для никс-систем(линукс и мак ?):
# https://rvm.io/    -  лучше использовать только 1е две команды, тк 3я это установка Рэилс и лучше его установить отдельно
# > rvm install 3.0.3     -  (после пункта выше) Установка, где цифры это версия Руби
# > rvm use 3.0.3     -  (после пункта выше) Переключение версии Руби, где цифры это версия Руби



# 3. (Не пробовал) В конспектах рубишколы на гитхаб так же есть ruby через RVM и другие штуки:
# 	Установка ruby через RVM
# 		1. Посмотрим доступные версии Rails:  gem search '^rails$' --all
# 		2. Чтобы установить конкретную версию, введите (вместо rails_version - номер версии): gem install rails -v rails_version
# 		3. С помощью gemset-ов можно использовать вместе разные версии Rails и Ruby. Это делается с помощью команды gem.
# 			rvm gemset create gemset_name # create a gemset
# 			rvm ruby_version@gemset_name  # specify Ruby version and our new gemset
# 			Gemset-ы позволяют создавать полнофункциональные окружения для gem-ов, а также настраивать неограниченное количество окружений для каждой версии Ruby.
# https://github.com/DefactoSoftware/Hours


puts
puts '                                           Создание приложения'

# > rails new name   -  cоздаcт новое рейлс-приложение в выбранной папке(вручную ничего делать не нужно), где последнее слово на выбор это имя директории приложения(например blog). Устанавливаются все необходимое для работы приложения, гемы, инициализируется гит итд.
# Название без нижних подчеркиваний в камэлкейс, но можно с большой буквы

# > rails new name -T               -  создать новое Рэилс приложение без автотестов
# > rails new name --skip-hotwire   -  создать новое Рэилс приложение без hotwire(отдельное большое решение для фронтэнда, это то что отвечает за всякие turbo-хрени, тоесть так будет работать боз них)

# Доп опции Рэилс 7 при создании приложения:
# настройка ассетов для CSS:
# > rails new name --css bootstrap
# > rails new name -T --css tailwind   - можно вместе с -T естественно
# > rails new name --css bulma
# > rails new name --css postcss
# > rails new name --css sass
# Движки для JS(inpostmap-rails - ставится по умолчанию, не делат bundle для js, а подключает модули напрямую):
# (устанавливаемые: esbuild, rollup.js, Webpack(раньше использовали только его потому встречается чаще всех))
# > rails new name -j webpack


# > rails new blog                                                 -  для курса рубишколы
# > rails new AskIt -T --css bootstrap -j webpack --skip-hotwire   -  для курса Круковского


# В итоге появляется папка с выбранным именем, которая содержит все необходимые стартовые папки и фаилы(далее обозначим f - фаил, d - папка):
# f .git
# d app              -  содержит отдельные папки views, models, controllers итд. По сути тут весь основной код приложения
# d bin              -  бинарные фаилы зафиксированные на версии(rails запустит приложение в той версии на которой оно создано)
# d config           -  конфигурация содержит, например:
#     d enviroments  -  настройки для каждого из 3х видов окружения(development.rb, test.rb и production.rb)
#     f boot.rb;
#     f routes.rb    -  фаил для установки маршрутов;
# d db
# d lib              -  доп фаилы
# d log              -  журналы событий
# d public           -  публичные фаилы передаваемые напрямую минуя приложение, просто в ответ на запрос
# d storage          -  все что связано с актив сторэдж
# d test
# d tmp
# d vendor           -  сейчас уже особо не используется
# f .gitattributes
# f .gitignore
# f .ruby-version
# f config.ru
# f Gemfile          -  все библиотеки и их версии для корректной работы приложения
# f Gemfile.lock
# f Rakefile
# f README.md


# Изменения для курса Круковского(делаем последовательно):
# в фаиле package.json(содержит библиотеки для фронтэнда) добавим строки "@rails/ujs": "^6.0.0" и "turbolinks": "^5.2.0"(2е для более быстрой загрузки страниц при переходе по ссылкам)
# > yarn install       - переинсталируем после пред пункта
# в фаиле app/javascript/application.js     - вносим изменения(они там и описаны)


puts
puts '                                       Запуск бандла. Ошибки Windows'

# (!!! На Виндоус(64), решение для Рэилс 7). По умодлчанию будет выдавать ошибку таймзон(tzinfo-data is not present. Please add gem 'tzinfo-data' to your Gemfile and run bundle install (TZInfo::DataSourceNotFound)), поэтому нужны манипуляции:
# 1. Изменить/подкрутить Gemfile. Найти в нем строку:
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]   # удаляем тут хэш доп настроек ...
gem 'tzinfo-data'                                                 # ... сохраняем так
# 2. > gem uninstall tzinfo-data

# > bundle install |или| > bundle update(лучше тк можно не писать gem uninstall tzinfo-data ??)

# (!!! Далее могут быть проблемы в Виндоус, если запустить приложение в PowerShell или Git Bash, тк у них проблемы с регистром(не воспринимают заглавные), потому нужно прописать вручную либо использовать классическую командную строку !!!)
# https://discuss.rubyonrails.org/t/getting-started-with-rails-no-template-for-interactive-request/76162

# (Не делал, от айтипрогер)Можно в гемфаил заменить в строке source "https://rubygems.org" https на http на время разработктки, тк корректнее для локального сервера ??


puts
puts '                                    Запуск сервера. Режимы запуска'

# Запуск сервера приложения
# (запускаем в основной папке приложения, если хотим запустить на последней версии Рэилс из установленных)
# (запускаем из директоррии appname/bin, чтобы запустить на той версии Рэилс на которой приложение было созданно)
# > rails server           - запуск в текущей консоли
# > rails s
# > start rails server     - запуск в новом окне консоли
# > start rails s


# Далее запускается Рэилс-сервер, среди прочего он говорит, что запускается на порту, например 3000(http://127.0.0.1:3000/)
# http://localhost:3000/  -  адрес для открытия рэилс приложений

# Последовательность того как начинает работу rails-приложение, когда его запускаешь:
# boot.rb -> rails -> environment.rb(подгружается) -> development.rb или test.rb или production.rb(подгружается окружение)


# Rails-приложение по умолчанию может запускаться в 3 разных типах окружения(режимах):
# 1. development - оптимизирует среду для удобства разработки, будет работать чуть медленнее.
# 2. test        - для тестирования
# 3. production  - запускает только то что нужно для работы приложения, работает максимально быстро
# Для каждого типа окружения существует своя отдельная БД

# Запуск окружения (development, test, production) через ключ -e (enviroment/окружение). По умолчанию окружение development
# > rails s -e development
# > rails s -e test
# > rails s -e production

# Можно создавать и собственные среды


puts
# Запуск приложения с курса Круковского. Не подойдет стандартный вариает, тк надо запустить вебпакер и перекомпилировать наши scss каждый раз когда они меняются
# На никс-системах мы просто ввели бы в терминал bin\dev и сервер бы запустился, но на Винде надо:
# зайдем в bin\dev и либо просто копируем команду(foreman start -f Procfile.dev) и запускаем ее в терминале, либо можно создать отдельный фаил, например st.cmd скопировать в него данную строку и запускать уже его:
# > st.cmd
# Но будет еще одна ошибка тк пытается использовать фаил bin\rails, но на виндоус это не работает. Нужно сделать изменения в фаиле Procfile.dev(он запускает: 1 Сервер Рэилс, 2 Компиляцию JS, 3 Компиляция для CSS) в нем неняем первую строку(web: env RUBY_DEBUG_OPEN=true bin/rails server) на другую: web: ruby bin/rails server ( ?? или web: ruby bin/rails server env RUBY_DEBUG_OPEN=true ?? проверить)


puts
puts '                                             Ошибки разное'

# 0. Если чтото не работает сперва перезапустить рэилс сервер приложения

# 1. tmp\pids\server.pid  # Автоматически удаляется когда закрываем сервер, но если что-то пошло не так и он не удалился, то сервер может перестать запускаться, тогда этот фаил нужно удалить вручную
















#