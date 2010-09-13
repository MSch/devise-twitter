devise-twitter
==========

Devise-twitter adds **Sign in via Twitter** and **Connect your account to
Twitter** functionality to your [devise][1] app.

It requires at least Devise 1.1 and ONLY works with Rails 3.

Current status
--------------

Devise-twitter currently supports *Sign in via Twitter* and *Connect your
account to Twitter*, but no proper API for *Connect your account to Twitter*
exists so far.

This plugin is in use in an upcoming product and continues to be improved.

Installation
------------

Simply add devise-twitter to your Gemfile and bundle it up:

    gem 'devise-twitter'

Run the generator, supplying the name of the model (e.g. User)

    $ rails generate devise:twitter user

Add your OAuth credentials to `config/initializers/devise_twitter.rb` 

    Devise::Twitter.setup do |config|
      config.consumer_key = <YOUR CONSUMER KEY HERE>
      config.consumer_secret = <YOUR CONSUMER SECRET HERE>
      config.scope = :user
    end

Modify your user model like so

    class User < ActiveRecord::Base
      # To use devise-twitter don't forget to include the :twitter_oauth module:
      # e.g. devise :database_authenticatable, ... , :twitter_oauth
    
      # IMPORTANT: If you want to support sign in via twitter you MUST remove the
      #            :validatable module, otherwise the user will never be saved
      #            since it's email and password is blank.
      #            :validatable checks only email and password so it's safe to remove
    
      # Include default devise modules. Others available are:
      # :token_authenticatable, :confirmable, :lockable and :timeoutable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable :twitter_oauth
    
      # Setup accessible (or protected) attributes for your model
      attr_accessible :email, :password, :password_confirmation, :remember_me
    end


Modify the generated routes (in `config/routes.rb`) to your liking

    Application.routes.draw do
      devise_for :user do
        match '/user/sign_in/twitter' => Devise::Twitter::Rack::Signin
        match '/user/connect/twitter' => Devise::Twitter::Rack::Connect
      end
      ...

Run the generated migration

    $ rake db:migrate



Signing in via Twitter
----------------------

When signing in via Twitter, after authorizing access on www.twitter.com,
devise-twitter will sign in an existing user or create a new one, if no user
with these oauth credentials exists.


Connect your account to Twitter
-------------------------------

Devise-twitter supports adding Twitter credentials to an existing user account
(e.g. one that registered via email/password) but currently the API to expose
this feature is far from perfect:

After navigating to `/user/connect/twitter` and authorizing access on
www.twitter.com, devise-twitter checks if there is another user with the same
twitter handle. If not devise-twitter adds twitter handle and oauth credentials
to the current user and saves.

If another user with the same twitter handle is found devise-twitter sets the
session variable `warden.user.twitter.connected_user.key` to the id of this
user. Your application can check if this variable is set and display an option
to merge the two users.

    if connected_user = session['warden.user.twitter.connected_user.key'].present?
      connected_user = User.find(connected_user)

      # Ask user if she/he wants to merge her/his accounts
      # (or just go ahead and merge them)
    end

If you have any idea how to improve it, please message me.

Database changes
----------------

The generated migration adds three fields to your user model:

    change_table(:users) do |t|
      t.column :twitter_handle, :string
      t.column :twitter_oauth_token, :string
      t.column :twitter_oauth_secret, :string
    end

    add_index :users, :twitter_handle, :unique => true
    add_index :users, [:twitter_oauth_token, :twitter_oauth_secret]

Currently the names of these fields are hard coded, but making them
customizable is on the roadmap.



Acknowledgements
----------------

Thanks to

* [Daniel Neighman](http://twitter.com/hassox) for creating warden, the framework Devise uses
* [Jose Valim](http://twitter.com/josevalim) for creating Devise
* [Pelle Braendgaard](http://stakeventures.com/pages/whoami) for implementing oauth support in Ruby
* [Roman Gonzalez](http://www.romanandreg.com/) for creating warden_oauth, the framework devise-twitter uses
* all the other giants who's shoulders this project stands on


Meta
----

* Code: `git clone http://github.com/MSch/devise-twitter`
* Bugs: <http://github.com/MSch/devise-twitter/issues>
* Gems: <http://rubygems.org/gems/devise-twitter>

[1]:http://github.com/plataformatec/devise
