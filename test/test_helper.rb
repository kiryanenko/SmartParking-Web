ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def assert_redirected_to_auth(*args)
    args.to_h.each_pair do |path, method|
      case method.downcase
      when 'get'
        get path
      when 'post'
        post path
      when 'patch'
        patch path
      end
      assert_redirected_to new_user_session_path
    end
  end
end
