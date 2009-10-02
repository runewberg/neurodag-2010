class Page < ActiveRecord::Base
  belongs_to :conference
  has_many :pages
  acts_as_tree :order => "created_at"

  # attr_accessor :video_url

  # def video_url
  #   video = self.videos.find(:first) 
  #   if video 
  #     video.url
  #   else
  #     ""
  #   end
  # end
  # 
  # def video_url=(url)
  #   logger.debug("VIDEO:" + url)
  #   # delete videos of page
  #   self.videos.delete_all
  #   # add new video to videos of page
  #   self.videos << Video.create(:url => url)
  # end  
  
end
