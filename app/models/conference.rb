class Conference < ActiveRecord::Base

  has_many  :registrations, :dependent => :destroy 
  has_one   :competition, :dependent => :destroy
  has_many  :pages, :dependent => :destroy
  has_many  :blogs, :dependent => :destroy
  
  has_many :attendees, :through => :registrations, :source => :user, :dependent => :destroy 
  
  has_many :posters,
           :order => "updated_at DESC", 
           :dependent => :destroy 
  
  has_many :talks,         
            :order => "updated_at DESC", 
            :dependent => :destroy
  
  # named_scope :recent, lambda { |*args| {:conditions => ["date > ?", (args.first || 2.weeks.ago)]} }

  def published_pictures
    Pictures.all :conditions => ["status = 'published' "], :order => 'updated_at DESC'
  end
     
  def poster_count
    posters.size
  end   

  def attendant_count
    attendees.size
  end   

  def talk_count
    talks.size
  end   

  def date
    if self.year
      self.year.to_s(:vshort)
    else
      ""
    end
  end
      
  def active?
    if self.year
      self.year.strftime('%Y') == current_year
    else
      false
    end
  end
  
private  
  def current_year
    Time.now.strftime('%Y')
  end  
end
