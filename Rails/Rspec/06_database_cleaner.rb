puts '                                         database_cleaner(устарело?)'

# (!!! Нифига не работает как и подсказки из уроков)

# Если в предыдущем тесте написать before(:all) вместо before(:each) то появится ошибка в тесте visitor_creates_account_spec.rb, тк он запустился позже этого и там мы тоже использовали хэлпер sign_up, соотв имэил для регистрации был уже использован, а БД не была очищена

# database_cleaner - гем для rspec и capibara, который очищает БД перед каждым тестом
# https://github.com/teamcapybara/capybara#transactions-and-database-setup
# https://github.com/DatabaseCleaner/database_cleaner#rspec-example

# Добавить в Gemfile:
group :test do
  # ...
  gem 'database_cleaner'
end

# Создадим файл конфигурации database_cleaner в файле /spec/support/database_cleaner.rb:
RSpec.configure do |config| # хэлпер конфигурирует/настраивает rspec
  config.before(:suite) do # перед запуском всего устанавливаются опции клинера
    DatabaseCleaner.strategy = :transaction # стратегия транзакция(очищаем БД при помощи ролбека)
    DatabaseCleaner.clean_with(:truncation) # очистка БД способом truncate(альтернатива delete)
  end

  config.around(:each) do |example| # будем очищать для каждого теста
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

# Потом в rails_helper.rb требуем этот файл то есть пишем - require 'support/database_cleaner', либо раскомментируем автоматическое добавление













# 
