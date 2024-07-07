puts '                                          simplecov'

# https://github.com/simplecov-ruby/simplecov

# simplecov - гем для определения процента покрытия проекта тестами, смотрит каждую строку кода и проверяет отрабатывает ли она при запуске тестов, тоесть покрыта тестами или нет

# Gemfile:
gem 'simplecov', require: false, group: :test
# > bundle install

# Загрузите и запустите SimpleCov в самом верху вашего test/test_helper.rb или spec_helper.rb, rails_helper, cucumber env.rb, или любого другого используемого фреймворка для тестирования:
require 'simplecov' # должно быть подключено раньше
# Вар 1. Просто включаем
SimpleCov.start  # этот код должен быть раньше подключения фаилов которые тестируем
# Вар 2. Можно передать блок с настройками
SimpleCov.start do
  add_filter 'spec/' # исключаем из проверки на покрытие саму директорию с тестами
end
require_relative '../hero' # Если SimpleCov запустится после того, как ваш код приложения уже загружен (через require), он не сможет отслеживать ваши файлы и их покрытие! SimpleCov.start должен быть загружен до того

# Теперь когда запустим тесты внизу будет инфа о проценте покрытия
# > rspec .
#=>
# Coverage report generated for RSpec to E:/doc/ruby_exemples/main/exeptions_testing/rspec_examples/coverage. 19 / 19 LOC (100.0%) covered.
# Stopped processing SimpleCov as a previous error not related to SimpleCov has been detected

# Так же создается директория /coverage в ней есть фаил index.html, который можно открыть в браузере и в удобном графическом формате посмотреть подробную информацию по фаилам о покрытии тестами, в том числе конкретные строки кода покрытые(зеленый) или не покрытые(красный)
# Стоит добавлять папку coverage в .gitignore    -  coverage/*















#
