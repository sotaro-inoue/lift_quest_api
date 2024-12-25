# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
  config.change_headers_on_each_request = false
  config.token_lifespan = 2.weeks
  config.batch_request_buffer_throttle = 5.seconds

  config.default_callbacks = true
  config.bypass_sign_in = true
  config.enable_standard_devise_support = true

  config.headers_names = {
    'authorization': "Authorization",
    'access-token': "access-token",
    'client': "client",
    'expiry': "expiry",
    'uid': "uid",
    'token-type': "token-type"
  }
end
