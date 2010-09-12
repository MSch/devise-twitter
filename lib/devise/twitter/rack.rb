module Devise
  module Twitter
    module Rack
      Signin = proc do |env|
        warden = env['warden']
        session = env['rack.session']
        request = ::Rack::Request.new(env)
        scope = env["devise.mapping"].singular

        if request.params.include?('oauth_token')
          # We got a redirect from Twitter back

          # Perform _only_ the twitter_oauth strategy.
          # Emulate _perform_authentication in _warden/proxy.rb
          strategy = warden.send(:_fetch_strategy, :twitter_oauth, scope)
          strategy.authenticate!
          if strategy.user
            warden.set_user(strategy.user, :event => :authentication, :scope => scope)
          end

          redirect_to Warden::OAuth::Utils.host_with_port(request)
        else
          # Perform the redirect to Twitter
          strategy = warden.send(:_fetch_strategy, :twitter_oauth, scope)

          # warden_oauth would always redirect to / so we need to hook into it
          request_token = strategy.consumer.get_request_token(:oauth_callback => request.url)
          strategy.instance_variable_set(:@request_token, request_token)

          # warden_oauth does exactly this if params.include? warden_oauth_provider
          # which we also hack around
          strategy.send(:store_request_token_on_session)
          redirect_to request_token.authorize_url
        end
      end

      Connect = proc do |env|
        # Check that user exists in DB, otherwise we'll get 'user with access token not found'
        # But since connecting to twitter only makes sense for existing users that's ok
        # TODO: If our user is unobtrusive redirect_to :back
        scope = env["devise.mapping"].singular
        env["warden.#{scope}.twitter.perform_connect"] = true

        Signin.call(env)
      end

      private

      # Stolen from action_dispatch/routing/mapper.rb
      def self.redirect_to(url)
        status = 302 # Found
        body = %(<html><body>You are being <a href="#{ERB::Util.h(url.to_s)}">redirected</a>.</body></html>)

        headers = {
          'Location' => url.to_s,
          'Content-Type' => 'text/html',
          'Content-Length' => body.length.to_s
        }

        [ status, headers, [body] ]
      end
    end
  end
end
