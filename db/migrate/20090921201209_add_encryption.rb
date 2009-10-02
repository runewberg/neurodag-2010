class AddEncryption < ActiveRecord::Migration
    def self.up
      add_column :users, :crypted_password, :string
      remove_column :users, :password
    end

    def self.down
      remove_column :users, :crypted_password
      add_column :users, :password, :string
    end
end
