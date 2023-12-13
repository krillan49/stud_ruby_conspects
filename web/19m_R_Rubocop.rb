puts '                                         Rubocop'

# https://docs.rubocop.org/rubocop/1.59/index.html

# Rubocop - это инструмент (гем), специальный анализатор кодав, который следит за стилем кода который мы пишем, в соответсвии с существующими соглашениями для стиля. Может сообщать о стилистических ошибках или исправлять некоторые автоматически.


# Установка для Рэилс: https://docs.rubocop.org/rubocop/1.59/installation.html
group :development do # добавим только для среды development
  gem 'rubocop', '~> 1.59', require: false
  # так же добавим 2 гема-расширения для Рубокопа(все расширения можно посмотреть во вкладке меню Projects в доках)
  gem 'rubocop-rails', '~> 2.22', require: false  # доп проверки для Рэилс https://github.com/rubocop/rubocop-rails
  gem 'rubocop-performance', '~> 1.19', require: false # доп проверки на производительность кода
end
# > bundle i


# Сконфигурируем Рубокоп: https://docs.rubocop.org/rubocop/1.59/configuration.html
# .rubocop.yml - нушно создать конфигурационный фаил с таким названием в корневой папрке прокта(создадим и заполним тут)
# https://github.com/rubocop/rubocop/blob/master/.rubocop.yml  - пример содержания .rubocop.yml


# Запуск проверки(в корневой директории проекта)
# > rubocop                    # обычный
# > bundle exec rubocop        # с версиями гемов из гемфаила
# В итоге выдасть список стилистических ошибок(каждая такая проверка называется cop) с их описаниями, а так же их колличество и сколько можно исправить автоматически


# Автоматическое исправление тех ошибок, что можно исправить автоматически
# > bundle exec rubocop -A        # агрессивное исправление, придирается к совсем мелким ошибкам и находит больше
# > bundle exec rubocop -a        # более безопасный режим исправления
# После исправления выдаст отчет как выше с описанием оставшихся ошибок и цифрами сколько исправлено из скольки


puts '                             Ручное исправление оставшихся ошибок'

# https://docs.rubocop.org/rubocop-rails/cops.html   - посмотреть копы для рэилс

# Структура копа: директория фала с ошибкой, название копа, описание ошибки, место в коде выделенное ^^^:
# app/controllers/concerns/authentication.rb:6:3: C: Metrics/BlockLength: Block has too many lines. [44/25]
#   included do ...
#   ^^^^^^^^^^^


# Примеры ошибок, на примере AskIt:


# Style/Documentation: Мissing top-level class documentation comment
# Говорит о том что нет докумментации для нашего класса, можно задокумментировать или отключить эти проверки в настройках .rubocop.yml, тут отключим в настройках


# Rails/FilePath  - ошибка путей в некоторых записях. Есть 2 варианта записи через слэш slashes('some/some')(значение по умолчанию) или отдельно arguments ('some', 'some'). Установим в .rubocop.yml, что хотим чтоб правильно было отдельно. Какие данные и как прописывать в ямл смотрим в описании копов в доках


# Layout/LineLength: Line is too long. [152/120]  - слишком длинная линия, просто разобьем строку на части в самом коде
'complexity requirement not met. Length should be 8-70 characters and ' \
'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'


# Rails/SkipsModelValidations: Avoid using update_column because it skips validations. - Говорит о том что метод update_column лучше не использовать, тк все валидации прпускаются
# Эта проверка нам не критична и можно ее отключить, но глобально ее отключать не хотелось бы, поэтому можем отключить ее только для конкретных строк в коде при помощи специальных комментариев, которые будут отключать проврку перед нужной строкой и включать после нее
def remember_me
  self.remember_token = SecureRandom.urlsafe_base64
  # rubocop:disable Rails/SkipsModelValidations
  update_column :remember_token_digest, digest(remember_token)
  # rubocop:enable Rails/SkipsModelValidations
end
# где Rails/SkipsModelValidations - название копа


# Rails/OutputSafety: Tagging a string as html safe may be a security risk.  - исправляем так же как и выше
def pagination(obj)
  # rubocop:disable Rails/OutputSafety
  raw(pagy_bootstrap_nav(obj)) if obj.pages > 1
  # rubocop:enable Rails/OutputSafety
end


# Metrics/BlockLength: Block has too many lines. [44/25]  - говорит о том, что блок кода в консерне слишком большой. Но тк этот блок содержит все методы консерна, то это корректно и потому тоже отключим
module Authentication
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    # ...
  end
  # rubocop:enable Metrics/BlockLength
end


# Metrics/AbcSize: Assignment Branch Condition size for current_user is too high. [<5, 21, 6> 22.41/17] - в методе current_user слишком много кода и нужно его отрефакторить(concerns/authentication.rb)


# Metrics/AbcSize: Assignment Branch Condition size for create is too high. [<3, 20, 5> 20.83/17]  - тоже слишком много кода в экшене create контроллера sessions. Отрефакторим















#
