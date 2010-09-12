Devise::Twitter.setup do |config|
  config.consumer_key = <YOUR CONSUMER KEY>
  config.consumer_secret = <YOUR CONSUMER SECRET>
  config.scope = :<%= singular_name %>
end

