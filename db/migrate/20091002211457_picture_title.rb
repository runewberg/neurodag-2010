class PictureTitle < ActiveRecord::Migration
  def self.up
    rename_column :pictures, :label, :title
  end

  def self.down
    rename_column :pictures, :title, :label    
  end
end
