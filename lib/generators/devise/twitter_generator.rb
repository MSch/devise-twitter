require 'rails/generators/active_record'

module Devise
  module Generators
    class TwitterGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      def add_migration
        migration_template "migration.rb", "db/migrate/add_devise_twitter_fields_to_#{table_name}"
      end

      def inject_devise_twitter_intomodel
        inject_into_class model_path, class_name, <<-CONTENT
  # To use devise-twitter don't forget to include the :twitter_oauth module:
  # e.g. devise :database_authenticatable, ... , :twitter_oauth

CONTENT
      end

      def copy_initializer
        template "initializer.rb", "config/initializers/devise_twitter.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end

      private
      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
