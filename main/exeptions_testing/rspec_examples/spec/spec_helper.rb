require 'simplecov'

SimpleCov.start do
  add_filter 'spec/'
end

require_relative '../demo' # подключится перед запуском всех тестов
require_relative '../hero'
