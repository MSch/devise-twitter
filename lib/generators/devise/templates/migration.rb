class AddDeviseTwitterFieldsTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table(:<%= table_name %>) do |t|
      t.column :twitter_handle, :string
      t.column :twitter_oauth_token, :string
      t.column :twitter_oauth_secret, :string
    end

    add_index :<%= table_name %>, :twitter_handle, :unique => true
    add_index :<%= table_name %>, [:twitter_oauth_token, :twitter_oauth_secret]
  end

  def self.down
    remove_index :<%= table_name %>, :column => :twitter_handle
    remove_index :<%= table_name %>, :column => [:twitter_oauth_token, :twitter_oauth_secret]

    change_table(:<%= table_name %>) do |t|
      t.remove :twitter_handle, :string
      t.remove :twitter_oauth_token, :string
      t.remove :twitter_oauth_secret, :string
    end
  end
end
