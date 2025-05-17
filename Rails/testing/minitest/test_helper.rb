ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "mocha/minitest"
require "action_policy/test_helper"
# require "action_policy/minitest"      # cannot load such file -- action_policy/minitest (LoadError)

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  include FactoryBot::Syntax::Methods
  include ActionPolicy::TestHelper

  # Run tests in parallel with specified workers
  # parallelize(number_of_workers: :number_of_processors)

  # fixtures :all — включай, если пользуешься fixtures, иначе можно убрать
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
