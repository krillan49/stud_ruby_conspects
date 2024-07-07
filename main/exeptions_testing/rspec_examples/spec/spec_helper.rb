require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f} # подключим все фаилы из support/

require_relative '../demo' # подключится перед запуском всех тестов
require_relative '../hero'

# подключим модуль с методом из support/ во все тесты
RSpec.configure do |c|
  c.include TestObj
end
# ?? RSpec.configure - это массив со всми тестами ??
