puts '                                  Способы запуска тестов'

# 1. Все тесты
# $ bundle exec rspec
# $ bin/rspec                           - или короче (если rspec в bin)

# 2. Конкретная директория
# $ bin/rspec spec/models               - только модели
# $ bin/rspec spec/features             - только системные тесты (фичи)
# $ bin/rspec spec/components           - только компоненты

# 3. Один файл
# $ bin/rspec spec/models/user_spec.rb

# 4. Один конкретный тест
# $ bin/rspec spec/models/user_spec.rb:15    - тут 15 номер строки с it или scenario

