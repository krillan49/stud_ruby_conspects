require 'simplecov'
require 'webmock/rspec'

# определение % покрытия проекта тестами
SimpleCov.start do
  add_filter 'spec/' # директория исключенная из расчетов % покрытия тестами
end

# фаилы код из которых тестируем, подключится перед запуском всех тестов
require_relative '../demo'
require_relative '../hero'
require_relative '../api'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f} # подключим все фаилы из support/

# подключим модуль с методом из support/ во все тесты
RSpec.configure do |c|
  c.include TestObj
end
# ?? RSpec.configure - это массив со всми тестами ??
