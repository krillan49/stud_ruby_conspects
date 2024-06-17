puts '                                     Создание своего гема'

# Создадим гем fun_translations - клиент по взаимодействию с API https://api.funtranslations.com/ которое отвечает на запросы по определенным URL для каждого типа переводов, например отправляем текст на https://api.funtranslations.com/translate/yoda.json и получаем в отвед перевод на слэнге Йоды



puts '                                    Создание gemspec и Gemfile'

# 1. Создадим спецификацию (gemspec) для нашего гема. Описывает что это за библиотека. Нужна для того чтобы библиотека была потом правильно скомпилирована и правильно установлена (сбилдена)
# /fun_translations.gemspec    - называется так же как гем с расширением gemspec (описание там)

# 2. Создадим Gemfile в корневой дирктории и подключим в него fun_translations.gemspec, чтоб добавить зависимости (код там)
# > bundle install



puts '                                 Создание структуры исходного кода гема'

# https://github.com/fxn/zeitwerk

# 1. Создадим главный путь/директорию нашей библиотеки в которой лежит весь исходный код
# /lib

# 2. Создадим главный входной(энтри поинт) фаил гема для загрузки всего проекта, который будет содержать основную настройку библиотеки, а так же загрузку всех необходимых фаилов. Используем в нем гем zeitwerk для удобства
# /lib/fun_translations.rb   - называется так же как гем (код там)

# 3. Создадим директорию /lib/fun_translations чтобы она соответствовала названию модуля FunTranslations, а внутри фаилы будут называться в соотв с именами классов, модулей или констант находящихся в них, которые вложены в модули FunTranslations. Директория будет содержать большинство фаилов исходного кода нашего гема.
# Тоесть если например гдето будет вызвано FunTranslations::Some.some - то это значит что класс/модуль или константа Some находится в модуле FunTranslations в фаиле fun_translations/some.rb

# 4. Создадим фаил с константой версиии fun_translations/version.rb и подключим ее в fun_translations.gemspec



puts '                                      Создание исходного кода гема'

# Создадим фаил lib/fun_translations/connection.rb с функционалом создания экземпляра Faraday для последующего подключения к API https://api.funtranslations.com/

# Создадим фаил lib/fun_translations/request.rb с функционгалом отправки пост запроса к API https://api.funtranslations.com/ по подключению из lib/fun_translations/connection.rb

# Создадим фаил lib/fun_translations/client.rb с методом translate, который уже будут напрямую использовать пользователи нашего гема, подключим туда функционал lib/fun_translations/request.rb для пост запроса

# Создадим фаил lib/fun_translations/translation.rb, который будет создавать объект класса Translation, который будет возвращен методом translate в lib\fun_translations\client.rb с переводом и другой инфой и методами их вызывающими.

# Во вхожном фаиле /lib/fun_translations.rb создадим в модуле метод, чтобы пользователь вызывал его, а не сам создавал образец класса Client



puts '                                          Компиляция нашего гема'

# Для компиляции нашего гема, тоесть создания скомпилированного фаила с гемом, который можно публиковать на Рубигемс:
# 1. Заходим в корневую директорию гема где находится фаил /fun_translations.gemspec
# 2. Запустим команду build, которая и компилирует нашу библиотеку, передав в него аргументом фаил спецификации:
# > gem build fun_translations.gemspec


# Возможные ошибки:

# (Изза отсутсвия фаилов указанных в spec.files или изза отсутсвия ридми в spec.extra_rdoc_files)
# WARNING:  See https://guides.rubygems.org/specification-reference/ for help
# ERROR:  While executing gem ... (Gem::InvalidSpecificationException)
#     ["README.md"] are not files


# Если все скомпилировалось нормально(тут с предупреждениями что не добавлены описания в spec.summary и spec.description)

# WARNING:  no summary specified
# WARNING:  description and summary are identical
# WARNING:  See https://guides.rubygems.org/specification-reference/ for help
#   Successfully built RubyGem
#   Name: fun_translations
#   Version: 0.0.1
#   File: fun_translations-0.0.1.gem


# В итоге создается скомпилированный фаил библиотеки с именем как у фаила спецификации + версией из спецификации и расширением gem:
# fun_translations-0.0.1.gem



puts '                             Установка гема локально из скомпилированного фаила'

# Можем установить наш гем из полученного скомпилированного фаила, например чтобы потестировать или просто использовать до того как опубликуем его на Рубиджемс. Установится все точно так же как и с Рубиджемс, в правильные директории Руби
# > gem install fun_translations-0.0.1.gem

# > gem uninstall fun_translations              -  удаление гема из системы

# Скомпилированный гем fun_translations-0.0.1.gem можно удалить если не нужен или оставить, если нужны фаилы всех версий



puts '                                   Как будет использоваться наш гем'

require 'fun_translations' # подключит наш гем

client = FunTranslations.client('1231231231sdfsdfsdf') # создаст экземпляр Client, тут с передачей необязательного токена(для последующего проброса в заголовки запроса) для авторизации в платной версии API, для бесплатной соотв его не передаем
result = client.translate :pirate, "Hello sir!" # выполнит запрос на перевод в нужном стиле, вернется экземпляр Translation
puts result.translated_text #=> "Ahoy matey!"   # получит переведенный текст от метода Translation

















#
