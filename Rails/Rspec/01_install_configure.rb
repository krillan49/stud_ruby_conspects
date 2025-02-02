puts '                                Установка и настройка Rspec для Rails'

# 1. Gemfile для окружений test и development:
group :test, :development do
  gem 'rspec-rails'
end
# > bundle install

# (! Из комментов, не пользовался)Для рельсов 6.1 в Gemfile нужен gem 'rexml'
# stackoverflow.com/questions/65479863/rails-6-1-ruby-3-0-0-tests-error-as-they-cannot-load-rexml


# 2. Настройка Rspec для Rails:
# > rails g rspec:install  - этот генератор(среди прочих, добавился при установке gem 'rspec-rails') запускает гем и выполняет его установку в наше приложение(установит дополнительные каталоги и хэлперы). Создались:
# .rspec                 - содержит опции/настройки(например для цветового вывода)
# spec                   - Директория для rspec тестов и других фаилов
# spec/spec_helper.rb
# spec/rails_helper.rb

# (! У меня не возникла)(Проблема из комментов: когда прописал команду rails g rspec:install после стоит на месте, нужно прервать и написать так DISABLE_SPRING=true rails generate rspec:install)


# 3. Тк тестовая БД(если ее используем) по умолчанию не содержит миграций, нужно их произвести чтобы не было ошибок
# > rails db:migrate RAILS_ENV=test















#
