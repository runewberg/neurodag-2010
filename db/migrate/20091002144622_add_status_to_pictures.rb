class AddStatusToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :status, :string
#    add_column :videos, :status, :string
  end

  def self.down
    remove_column :pictures, :status
#    remove_column :videos, :status
  end
end
