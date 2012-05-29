Warden::OAuth.access_token_user_finder(:twitter) do |access_token|
  perform_connect = (env["warden.#{@scope}.twitter.perform_connect"] == true)
  twitter_handle = access_token.params[:screen_name]
  klass = @env['devise.mapping'].class_name.constantize

  if perform_connect
    # Add twitter_handle to current user
    already_existing_user = klass.first(Devise::Twitter.twitter_handle_field => twitter_handle)
    if already_existing_user.blank?
      # We don't know anyone with this handle, therefore continue with connecting
      user = @env['warden'].user
      user.send("#{Devise::Twitter.twitter_handle_field}=",twitter_handle)
      user.send("#{Devise::Twitter.twitter_oauth_token_field}=", access_token.token)
      user.send("#{Devise::Twitter.twitter_oauth_secret_field}=", access_token.secret)
      user.save
      return user
    else
      # We already have such a user in our DB
      session["warden.#{@scope}.twitter.connected_user.key"] = already_existing_user.id
      return @env['warden'].user
    end
  else
    previous_user = @env['warden'].user

    # Try to find user by token
    user = klass.first(:Devise::Twitter.twitter_oauth_token_field=> access_token.token, Devise::Twitter.twitter_oauth_secret_field => access_token.secret)

    # Since we are logging in a new user we want to make sure the before_logout hook is called
    @env['warden'].logout if previous_user.present?

    if user.nil?
      # Create user if we don't know him yet
      user = klass.new
      user.send("#{Devise::Twitter.twitter_handle}=",twitter_handle)
      user.send("#{Devise::Twitter.twitter_oauth_token}=", access_token.token)
      user.send("#{Devise::Twitter.twitter_oauth_secret}=", access_token.secret)
      user.save
    end

    return user
  end
end
