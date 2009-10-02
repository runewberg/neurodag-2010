class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  
  has_attached_file :pic, :styles => { :medium => "200x200>", :thumb => "40x40>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml", :path => ":attachment/:id/:style.:extension", :url => 'neurodag_dev2.s3.amazonaws.com'  

  def owner
    user
  end
  
  def owner_name
    if owner
      owner.full_name
    else
      "-"
    end
  end

end
