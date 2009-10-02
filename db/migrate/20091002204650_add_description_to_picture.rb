class AddDescriptionToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :description, :text
  end

  def self.down
    remove_column :pictures, :description
  end
end
