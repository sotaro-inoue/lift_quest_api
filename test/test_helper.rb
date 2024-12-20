ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def sign_in_as(user)
      # DeviseTokenAuthの認証トークンを生成
      @auth_tokens = user.create_new_auth_token

      # ヘッダーにトークンを設定
      @headers = {
        'access-token' => @auth_tokens['access-token'],
        'client' => @auth_tokens['client'],
        'uid' => user.uid,
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end
  end
end
