module Devise
  module Twitter
    @@setup_done = false

    mattr_accessor :consumer_key
    @@consumer_key = nil

    # Private methods to interface with Warden.
    mattr_accessor :consumer_secret
    @@consumer_secret = nil

    mattr_accessor :scope
    @@scope = nil


    mattr_accessor :twitter_handle_field
    @@twitter_handle_field = "twitter_handle"
    
    mattr_accessor :twitter_oauth_token_field
    @@twitter_oauth_token_field = "twitter_oauth_token"

    mattr_accessor :twitter_oauth_secret_field
    @@twitter_oauth_secret_field = "twitter_oauth_secret"

    # Default way to setup Devise. Run rails generate devise_install to create
    # a fresh initializer with all configuration values.
    def self.setup
      raise "Can not invoke setup twice" if @@setup_done
      yield self
      @@setup_done = true

      Devise.warden do |manager|
        manager.oauth(:twitter) do |twitter|
          twitter.consumer_key  = @@consumer_key
          twitter.consumer_secret = @@consumer_secret
          twitter.options = {
            :site => "https://api.twitter.com",
            :request_token_path => "/oauth/request_token",
            :access_token_path => "/oauth/access_token",
            :authorize_path => "/oauth/authenticate",
            :realm => "http://api.twitter.com/"
          }
        end
        manager.default_strategies(:scope => @@scope).unshift :twitter_oauth
      end
    end
  end
end

