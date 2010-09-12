require 'rails/generators/active_record'

module Devise
  module Generators
    class TwitterGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      def add_migration
        migration_template "migration.rb", "db/migrate/add_devise_twitter_fields_to_#{table_name}"
      end
    end
  end
end
