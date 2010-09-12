module Devise
  module Twitter
  end
end

require "rack"
require "warden"
require "oauth"
require "warden_oauth"
require "devise"
require "devise/twitter"
require "devise/twitter/rack"
require "devise/twitter/warden"
require "devise/twitter/version"
