puts '                                            Rubocop'

# https://docs.rubocop.org/rubocop/1.64/index.html

# Rubocop - это гем, специальный анализатор кода, который следит за стилем кода который мы пишем, в соответсвии с существующими соглашениями, по умолчанию или в соответсвии с настройками в конфигурационном фаиле. Может сообщать о стилистических ошибках или исправлять некоторые автоматически. В итоге мы можем задать общий стиль для всех разработчиков учавствующих в проекте.


# Установка: https://docs.rubocop.org/rubocop/1.59/installation.html
group :development do
  gem 'rubocop', '~> 1.64', require: false
  # все гемы-расширения для Рубокопа можно посмотреть во вкладке меню Projects в доках
  gem 'rubocop-performance', '~> 1.21', require: false # доп проверки на производительность кода
  gem 'rubocop-rspec', '~> 3.0'                        # доп проверки для тестов гема rspec
end
# > bundle i


# Сконфигурируем Рубокоп: https://docs.rubocop.org/rubocop/1.59/configuration.html
# .rubocop.yml - нужно создать конфигурационный(настроечный) фаил с таким названием в корневой папке проекта (тут создадим в rspec_examples)
# https://github.com/rubocop/rubocop/blob/master/.rubocop.yml  - пример содержания .rubocop.yml



puts '                                        Запуск проверки'

# При запуске проверки пройдет все Руби фаилы проекта, в итоге выдаст список стилистических ошибок (каждая такая проверка называется 'cop') с их описаниями, а так же их колличество и сколько можно исправить автоматически

# Запуск проверки производится в корневой директории проекта:
# > rubocop                    # обычный запуск проверки
# > bundle exec rubocop        # с версиями гемов из гемфаила

# Структура копа: директория фала с ошибкой, название копа, описание ошибки, место в коде выделенное ^^^:
# app/controllers/concerns/authentication.rb:6:3: C: Metrics/BlockLength: Block has too many lines. [44/25]
#   included do ...
#   ^^^^^^^^^^^



puts '                                    Автоматическое исправление'

# Автоматическое исправление тех ошибок, что можно исправить автоматически:
# > bundle exec rubocop -a        # безопасный режим исправления
# > bundle exec rubocop -A        # агрессивное исправление, придирается к совсем мелким ошибкам и находит больше

# После исправления выдаст отчет с описанием оставшихся ошибок и цифрами сколько исправлено из скольки


puts '               Ручное исправление оставшихся ошибок. Синтаксис для игнора кода Рубокопом'

# https://docs.rubocop.org/rubocop/1.64/cops.html#available-cops    - посмотреть конкретные проверки


# Например для ошибки:

# app/controllers/concerns/authentication.rb:6:3: C: Metrics/BlockLength: Block has too many lines. [44/25]
#   included do ...
#   ^^^^^^^^^^^

# Эта проверка нам не критична и можно ее отключить, но глобально ее отключать не хотелось бы, поэтому можем отключить ее только для конкретных строк в коде при помощи специальных комментариев, которые будут отключать проврку перед нужной строкой и включать после нее
def remember_me
  self.remember_token = SecureRandom.urlsafe_base64
  # rubocop:disable Rails/SkipsModelValidations
  update_column :remember_token_digest, digest(remember_token)
  # rubocop:enable Rails/SkipsModelValidations
end
# где Rails/SkipsModelValidations - название копа

















#
