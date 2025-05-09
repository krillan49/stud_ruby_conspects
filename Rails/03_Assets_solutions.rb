puts '                                         Управление ассетами'

# Ассеты - это таблицы стилей, js-скрипты, изображения

# Транспайлинг - конвертация ECMAScript6 в обычный JS (нужно для старых браузеров) (транспайлинг все менее актуален)


# Раньше просто создавался JS-фаил и подключался через script-тег на html-странице (например в конце тега body):
'<script src="js/app.js"></script>'

# Но JS начал сильно развиваться, начали появляться разные сторонние решения, модули, фрэймворки и подгружать их стали через отдельные JS-фаилы - тоесть отдельно библиотеки(например jquery), отдельно утилиты, отдельно свои JS-фаилы итд:
'<script src="js/app.js"></script>'
'<script src="js/jquery.js"></script>'

# И когда этот столбец подключаемых скриптов стал огромным(например штук 15) это стало неудобно. К тому же нужно было контролировать версии всех подключаемых библиотек
# В итоге нужно было решение которое позволит всем этим управлять и придумали webpack и другие решения



puts '                                         Sprockets(устарело)'

# Сейчас Sprockets устаревает и лучше переходить на чтото другое
# Удаление Sprockets из приложения Рэилс:   https://www.youtube.com/watch?v=Vqh4wHdNXg8   20-55

# Sprockets - решение для управления ассетами(таблицы стилей, js-скрипты, изображения) в Рэилс
# Стоял в Рэилс 6- версий по умолчанию, в 7й версии если нужен то надо подключить через гем:
gem "sprockets-rails"

# Структура Sprockets:
# Все наши ассеты(изображения, таблицы стилей и js-скрипты) должны находиться в поддирректориях в директории assets

# Минусы Sprockets:
# Sprockets не очень заточено на модульный js;
# Устанавливать сторонние js-библиотеки с помощью него неудобно, тк приходится подключать сторонние гемы для фронтэнда в Gemfile, чтобы они подгодавливали ассеты таким образом, чтоб их можно было подгрузить в директории assets. А некоторые гемы перестают поддерживаться
# Нужно было обрабатывать отдельно например: sass  - для этого нужен был сторонний гем sass-rails; coffee-script - сторонний гем coffee-rails, чтобы превращать его в js; autoprefixer-rails - гем для автопрефиксов js на Рэилс; отдельно надо было устанавливать сторонние модули js и делать их бандл и транспайл.



puts '                                             app/assets'

# app/assets - директория с ассетами в Рэилс

# app/assets/images - директория для картинок

# asset_path - хэлпер возвращает путь к фаилу из директории app/assets/, например чтобы вставить его в какой-то хелпер, ?? по типу фаила определит, что тут надо искать в app/assets/images ??
asset_path 'avatar.jpg'

# app/assets/stylesheets - директория для css-стилей
# app/assets/stylesheets/application.css - главный фаил стилей, обычно его и другие css-фаилы называют манифестами (там можно посмотреть синтаксис Sprockets Assets Pipeline подключения css-фаилов в другие css-фаилы)



puts '                                            package.json'

# package.json - отвечает за решения связанные с фронтэндом, также как Gemfile отвечает за решения связанные с бэкэндом

# Синтаксис package.json
"bootstrap": "^5.3.2" # тут ^ значит что можно обновляться до версий 5.x.x но не до 6.x.x
"bootstrap": "5.3.2"  # нужно использовать именно эту версию и обновляться выше нельзя



puts '                                      Webpack. Webpacker(устарело)'

# https://webpack.js.org/

# Webpack - инструмент, который позволяет компоновать(собирать вместе) ассеты(JS, стили, изображения) и правильным образом их подготовить для развертывания в продакшене.


# Webpacker устарел. В феврале 2022 года Webpacker более не поддерживается сообществом и работа над ним остановлена.

# https://www.youtube.com/watch?v=Vqh4wHdNXg8   - миграция с Sprockets на Webpacker

# https://github.com/rails/webpacker
# Webpacker - связующее звено для скомпилированного и пакетного JS которое позволяет использовать в Рэилс приложении webpack. Позволяет собирать JS-модули, делать их транспайлинг и бандл, чтобы модули на ECMAScript можно было запускать в любых браузерах(поддержка старых браузеров). Удобно что никаких прослоек для js-скрипта не нужно.

# Webpacker отделяет описание всех решений в package.json, вместо того чтобы их хранить в Gemfile
# Нужно следить чтобы Webpacker был одной версии и в Gemfile и в package.json
# После обновления вебпакера нужно выпонить и yarn install

# Минусы Webpacker:
# Приходилось все равно частично использовать Sprockets и например гем sass-rails, получалась мешанина, потом когда sass-rails устарел пришлось использовать сам webpacker и для работы с таблицами стилей.
# Тоесть webpacker это довольно сложное решение, одновременно делает и бандл и транспайл и прекомпиляцию css и еще и отдает все эти ассеты клиентам. Сложные настройки, сложные миграции на другие версии, у новичка что-то постоянно будет ломаться



puts '                                            Решения для Рэилс 7'

# Команда, которая будет использовать все скрипты из package.json, ее конфигурируют гемы jsbundling-rails и cssbundling-rails
# > rails assets:precompile

# В Рэилс 7 разработчик может сам выбрать какие решения из множества существующих и для каких ассетов применять.

# Для Рэилс по умолчанию в Gemfile есть специальные гемы:
gem 'cssbundling-rails'
gem 'jsbundling-rails'
# При помощи этих гемов можно выбирать решения и для бандла css и для бандла js:

# 1. Бандлинг css  (необходим node.js c yarn, тк предварительная компиляция CSS будет осуществляться им)
# https://github.com/rails/cssbundling-rails
# Из коробки поддерживает решения: Tailwind CSS, Bootstrap, Bulma, PostCSS, Dart Sass
# > rails new myapp --css [tailwind|bootstrap|bulma|postcss|sass]
# Если при созданнии приложения не указать опцию --css с решением, тогда в приложении будет обычный css без препроцессоров и фрэймворков

# 2. Бандлинг js  (необходим node.js c yarn)
# https://github.com/rails/jsbundling-rails
# Из коробки поддерживает решения: Bun, esbuild, rollup.js, Webpack
# > rails new myapp -j [bun|esbuild|rollup|webpack]
# Если при созданнии приложения не указать опцию -j с решением, тогда в приложении будет использоваться новое решение по умолчанию - importmap-rails



puts '                                            importmap-rails'

# https://github.com/rails/importmap-rails

# importmap-rails - новое решение по умолчанию в Рэилс 7 для управления js-ассетами.
# С ним мы вообще не делаем ни транспайлинг ни бандлинг js-скрипта, а просто подключаем js-модуль написанный на ECMAScript и прямо так отдаем юзеру.

# Для importmap-rails не нужно устанавливать node.js

# Современные браузеры поддерживают ECMAScript, но какие-то еще не реализовали эту поддержку, тоесть для старых браузеров все равно нужен будет транспайлинг, а его в importmap-rails нет.
# Для использования sass все равно понадобится node.js или какието гемы
# Библиотеки устанавливаются необычно/неочевидно при помощи спец команд, а зависимости прописываются не в package.json а в специальном рубифаиле
# Нет удобного способа обновления компонентов (Возможно уже исправлено)



puts '                                               ESBuild'

# https://esbuild.github.io/

# ESBuild - современное, относительно простое в использовании и быстрое решение (?? управляет только JS)

# ?? Не использует транспайлинг ?? тк использует ECMAScript6 модули, тк все современные браузеры уже их поддерживают



puts '                                               Vite Ruby'

# https://github.com/ElMassimo/vite_ruby



puts '                               Переход с webpacker и webpack на ESBuild'

# https://www.youtube.com/watch?v=RG5mIXF_LP0   - c 10-21 переход с webpacker на esbuild


# Gemfile добавим гемы:
gem 'sprockets-rails'
gem 'jsbundling-rails'
gem 'cssbundling-rails'


# app/assets/   - cоздаем стандартные директории (код там):
# app/assets/config/manifest.js  - манифест, тут прописываем куда будут помещаться все скомпилированные ассеты(JS,CSS) и картинки
# app/assets/images/             - сюда(прописано в манифесте) будут помещаться все картинки
# app/assets/builds/             - сюда(прописано в манифесте) будут помещаться все скомпилированные ассеты(JS, CSS)
# app/assets/stylesheets/        - создадим директории для таблицы стилей(шаблонов для компиляции ассетов)

# Ассеты для app/assets/builds/ компилируются заново при каждом запуске сервера через 'foreman start -f Procfile.dev', тоесть даже если удалить все фаилы из директории stylesheets и запускать через 'rails s' то все стили и скрипты останутся, тк они все исполняются из скомпилированных js и css фаилов из app/assets/builds/, а сами фаилы в которых мы пишем стили и скрипты используются только как шаблоны для компиляции билда. Если же удались все ассеты (кроме картинок ??) то они просто заново скомпилируются по шаблону


# Установим bootstrap если он не установлен:
# > rails:css:install:bootstrap
# Создается фаил Procfile.dev, установит bootstrap и @popperjs/core если их у нас еще нет, так же добавит в лэйаут строчку <%= stylesheet_link_tag "application" %> те ссылку на app/assets/stylesheets/application.bootstrap.scss

# Перетаскиваем импорты стилей в app/assets/stylesheets/application.bootstrap.scss (A_application.bootstrap.scss), так же вынесем кастомные стили в _custom.scss и импортируем его в A_application.bootstrap.scss


# package.json - изменяем (удаляем все закоменченое тут)
# Для версии с вебпакером как у Круковского, а для моей с просто вебпаком удаляем то что совпадает
{
  "name": "ask-it",
  "private": true,
  "dependencies": {
    "@popperjs/core": "^2.9.2",
    "@rails/actioncable": "^6.0.0",            # этго у меня не было (добавить или устарело и и так подключено ??)
    "@rails/activestorage": "^6.0.0",          # этго у меня не было (добавить или устарело и и так подключено ??)
    "@rails/ujs": "^6.0.0",
    # "@rails/webpacker": "6.0.0-rc.6",        # удаляем вебпакер
    "autoprefixer": "^10.3.1",                 # автопрефиксер (можно удалить а можно и оставить)
    "bootstrap": "^5.1.0",
    # "css-loader": "^6.2.0",
    # "css-minimizer-webpack-plugin": "^3.0.2",
    # "mini-css-extract-plugin": "^2.2.0",
    "postcss": "^8.4.35",                      # оставляем как стандарт для Рэилс 7 (для префиксов)
    "postcss-cli": "^11.0.0",                  # у Круковского не было (оставляем как стандарт для Рэилс 7)
    # "postcss-flexbugs-fixes": "^5.0.2",      # удаляем все другое постксс
    # "postcss-import": "^14.0.2",
    # "postcss-preset-env": "^7.0.1",
    "sass": "^1.37.5",
    # "sass-loader": "^12.1.0",
    "tom-select": "^2.0.0",
    "turbolinks": "^5.2.0",
    # "webpack": "5.65.0",                     # вебпак
    # "webpack-cli": "4.9.1"
  },
  "version": "0.1.0",                          # этго у меня не было (чтото устаревшее ??)
  # "devDependencies": {
  #   "@webpack-cli/serve": "^1.5.2",
  #   "webpack-dev-server": "^4.0.0"
  # },
  # "babel": {
  #   "presets": [
  #     "./node_modules/@rails/webpacker/package/babel/preset.js"
  #   ]
  # },
  "browserslist": [                       # настройка автопрефиксера, добавляет настройку (можно удалить а можно и оставить)
    "defaults"                            # добавляем префиксы под современные браузеры (остальные в описании browserslist)
  ],
  # Для версии без вебпакера изначально с Рэилс 7 (у Круковского этого не было):
  "scripts": {
    # "build": "webpack --config webpack.config.js",     # вебпак естественно удаляем

    # С тем что далее это стандартный вариант для Бутстрап в Рэилс 7 и нужно так и оставить:

    "build:css:compile": "sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules", # компиляция css ассетов
    # build:css - команда при помощи которой мы будем делать билд, она обращается к фаилу application.bootstrap.scss и будет делать для него билд в builds/application.css
    # --load-path=node_modules - использует директорию node_modules (там фаилы для yarn нашего проекта ??)
    # "build:css": "sass --style compressed ... - можно прописать и так, чтобы сжимало получившийся фаил
    "build:css:prefix": "postcss ./app/assets/builds/application.css --use=autoprefixer --output=./app/assets/builds/application.css",
    # build:css:prefix - для префиксов, тут запускем автопрефиксер, тк просто в кучу через && записать его не выйдет
    "build:css": "yarn build:css:compile && yarn build:css:prefix", # запускаем скрипты для компиляции и префиксов
    "watch:css": "nodemon --watch ./app/assets/stylesheets/ --ext scss --exec \"yarn build:css\""
    # --watch - ключ говорит что при изменениях будет заново проделана компиляция, нужно только для девелопмента
  }
}
# > yarn install       # появится директория node_modules
# > yarn build:css     # исполняет команду build:css скомпилируем фаилы css командой (тоже что автоматически делается при запуске через 'foreman start -f Procfile.dev' ??)


# Установим в существующий проект ESBuild отдельной командой:
# > rails javascript:install:esbuild
# Добавит в лэйаут ссылку на скрипты, добавит директорию app/javascript с фаилом application.js и добавит записи в Procfile.dev и строку в package.json
{
  # ...
  "dependencies": {
    # ...
    "esbuild": "^0.20.0", # добавилось
    # ...
  },
  "scripts": {
    # ...
    # 1. Добавилась запись-скрипт, при помощи которого мы будем делать бандл JS:
    "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --public-path=/assets"
    # 2. Но если устанавливать esbuild при создании проекта то была бы такая:
    "build": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets"
    # 3. А у Круковского было так:
    "build": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds"
  },
  # ...
}
# javascript/application.js - нужно удалить import '@popperjs/core', тк дропдаун его загружает автоматически;


# config/initializers/assets.rb - так же если нет(переход с вебпакера) создать это фаил (для Sprockets)


# Далее удаляем из проекта все что связано с вебпаком и вебпакером (можно найти через поиск по webpack)
# Удаляем вебпакер из гемфаила


# Сделаем билд после всех изменений:
# > yarn build
# =>
# $ esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --public-path=/assets
#   app\assets\builds\application.js      340.0kb
#   app\assets\builds\application.js.map  549.0kb
# (!! Если произошла ошибка на Винде при выполнении команды, то надо в package.json в пути скрипта "build": "esbuild app/javascript/*.* --bu... заменить *.* на название фаила, получится "build": "esbuild app/javascript/application.js --bun)


# javascript_include_tag - ссылка с хелпером появится в лэйаут, соответсвенно ссылку с хелпером для вебпакера можно удалить


# bin/dev - создается данный фаил(шелл скрипт), если его не было, он устанавливает гем foreman и при помощи него запускает фаил Procfile.dev (в нем указываютмя инструкции чтобы поднять наш сервер и также запустить компиляцию ассетов)

# Теперь на *никс системах чтобы запустить сервер вместо 'rails s' введем команду:
# $ bin/dev
# На Wíndows это не работает, потому создаем фаил name.cmd (название любое) и копируем туда строку foreman start -f Procfile.dev из фаила bin/dev и будем выпонять команду:
# > name.cmd

# Procfile.dev  - в нем располагаются все те инструкции которые мы проделали
web: ruby bin/rails server              # запуск сервера ("ruby" в строку добавляем если на Wíndows)
js: yarn build --watch                  # запуск билда для js (из скриптов из package.json) (--watch - ключ говорит что при изменениях будет заново проделана компиляция, нужно только для девелопмента)
css: yarn watch:css                     # запуск билда для css (из скриптов из package.json), запускает скрипт watch:css, а он по инструкциям в package.json запускает уже стальные - прописано в строках скриптов(они выполняются в командной строке как бы ??)
worker: bundle exec sidekiq -q default  # необязательно, для того чтобы сразу же запускался и сайдкик(как бы на одном сервере ??)


# Команда, которая будет использовать все скрипты из package.json, ее конфигурируют гемы jsbundling-rails и cssbundling-rails
# > rails assets:precompile
# (! Если ошибка при исполнении команды - нужно посмотреть в app/assets/config/manifest.js не добавились/продублировались ли там лишние строки например такое дублирование //= link_tree ../builds//= link_tree ../builds соотв удаляем 2ю )



puts '                                           Propshaft'

# https://github.com/rails/propshaft

# Propshaft - свежее решение на замену Sprockets, +- аналогичное но работает быстрее. (тоже работает в связке с ESBuild)


# Переход с Sprockets на Propshaft:
# https://github.com/rails/propshaft/blob/main/UPGRADING.md   - иструкция по переходу


# Gemfile:
gem 'propshaft', '~> 0.8'
# gem 'sprockets-rails'      # удалим/закоментим
# > bundle install


# config/application.rb - удалить config.assets.paths << Rails.root.join('app','assets');

# Удалим манифест app/assets/config/manifest.js можно вместе с директорией config, тк больше это не нужно

# Если импортируем только некоторые платформы, которые вам нужны (вместо rails/all), удалите require "sprockets/railtie";


# Propshaft не полагается на assets_helpers ( asset_path, asset_url, image_url итд), как это делал Sprockets. Вместо этого он будет искать каждую url функцию в ваших CSS-файлах и корректировать их, включив в них дайджест ресурсов, на которые они ссылаются.
# Просмотрите CSS-файлы и внесите необходимые изменения:
"background: image_url('hero.jpg');"   # меняем все такие css ссылки в стилях
"background: url('/hero.jpg'); "       # на такие
# Добавляя / в начале пути, мы сообщаем Propshaft считать этот путь абсолютным. Это позволяет внешним библиотекам, таким как темы FontAwesome и Bootstrap, работать «из коробки»
"background: url('hero.jpg'); "        # ?? но у меня и без слэша работает ??


# Propshaft использует динамический преобразователь ресурсов в режиме разработки. Однако при локальном запуске команды assets:precompile переключится на преобразователь статических ресурсов. Таким образом, изменения в ресурсах больше не будут наблюдаться, и вам придется предварительно компилировать ресурсы каждый раз, когда вносятся изменения.
# Если вы хотите снова включить преобразователь динамических ресурсов, вам необходимо очистить целевую папку (обычно public/assets), и propshaft начнет обслуживать динамический контент из источника.
# Но при запуске сервера через bin/dev все будет преобразовываться как и с Sprockets
















#
