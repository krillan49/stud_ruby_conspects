puts '                                     Создание своего гема'

# Создадим гем fun_translations - клиент по взаимодействию с API https://api.funtranslations.com/ которое отвечает на запросы по определенным URL для каждого типа переводов, например отправляем текст на https://api.funtranslations.com/translate/yoda.json и получаем в отвед перевод на слэнге Йоды



puts '                                    Создание gemspec и Gemfile'

# 1. Создадим спецификацию (gemspec) для нашего гема. Описывает что это за библиотека. Нужна для того чтобы библиотека была потом правильно скомпилирована и правильно установлена (сбилдена)
# /fun_translations.gemspec    - называется так же как гем с расширением gemspec (описание там)

# 2. Создадим Gemfile в корневой дирктории и подключим в него fun_translations.gemspec, чтоб добавить зависимости (код там)
# > bundle install

# 3. Создадим главный путь/директорию нашей библиотеки в которой лежит весь исходный код
# /lib



puts '                                 Создание структуры исходного кода гема'

# https://github.com/fxn/zeitwerk

# 1. Создадим главный входной(энтри поинт) фаил гема для загрузки всего проекта, который будет содержать основную настройку библиотеки, а так же загрузку всех необходимых фаилов. Используем тут и zeitwerk для удобства
# /lib/fun_translations.rb   - называется так же как гем (код там)

# 2. Создадим директорию /lib/fun_translations чтобы она соответствовала названию модуля FunTranslations, а внутри фаилы будут называться в соотв с именами классов, модулей или констант находящихся в них, которые вложены в модули FunTranslations. Директория будет содержать большинство фаилов исходного кода нашего гема.
# Тоесть если например гдето будет вызвано FunTranslations::Some.some - то это значит что класс/модуль или константа Some находится в модуле FunTranslations в фаиле fun_translations/some.rb

# 3. Создадим фаил с константой версиии fun_translations/version.rb и подключим ее в fun_translations.gemspec



puts '                                      Создание исходного кода гема'

# Создадим фаил lib/fun_translations/connection.rb с функционгалом подключения к API https://api.funtranslations.com/. Для подключения используем Faraday

# Создадим фаил lib/fun_translations/request.rb с функционгалом отправки пост запроса к API https://api.funtranslations.com/ по подключению из lib/fun_translations/connection.rb

# Создадим фаил lib\fun_translations\client.rb с функциональностью(метод translate) который уже будут напрямую использовать пользователи нашего гема, подключим туда функционал lib/fun_translations/request.rb для пост запроса

# Создадим фаил lib/fun_translations/translation.rb, который будет создавать объект, который будет возвращен методом translate в lib\fun_translations\client.rb с переводом и другой инфой и методами их вызывающими.

# Во вхожном фаиле /lib/fun_translations.rb создадим в модуле метод, чтобы пользователь вызывал его, а не сам создавал образец класса Client



puts '                                          Компиляция нашего гема'



puts '                                     Как юзер будет использовать наш гем'

require 'fun_translations' # подключит наш гем

client = FunTranslations.client('1231231231sdfsdfsdf') # создаст экземпляр Client
result = client.translate :pirate, "Hello sir!" # выполнит запрос на перевод в нужном стиле, вернется экземпляр Translation
puts result.translated_text # получит переведенный текст от метода Translation

















#
