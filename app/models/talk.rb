class Talk < ActiveRecord::Base
    belongs_to :registration
    belongs_to :user
    belongs_to :conference

    ajaxful_rateable :stars => 5, :allow_update => true, :dimensions => [:research, :presentation_style, :organization] #, :cache_column => 'ctalk'
    
      named_scope :most_recent, :order => 'updated_at DESC', :limit => 5
    
  def owner
    user
  end

  def owner_name
    user.full_name
  end

    
  def owner=(u)
    user = u
  end  
  
  def any_rating?(user)
    rated_by?(user, :research) || rated_by?(user, :presentation_style) || rated_by?(user, :organization)
  end

  def every_rating?(user)
    rated_by?(user, :research) && rated_by?(user, :presentation_style) && rated_by?(user, :organization)
  end  
  
end
