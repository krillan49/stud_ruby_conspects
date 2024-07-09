require 'simplecov'
require 'webmock/rspec'

SimpleCov.start do
  add_filter 'spec/'
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each {|f| require f} # подключим все фаилы из support/

require 'fun_translations' # подключим главный фаил гема

RSpec.configure do |c| # подключим модуль с методом из support/ во все тесты
  c.include TestClient
end
