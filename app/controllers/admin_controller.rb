class AdminController < ApplicationController
  before_filter :check_admin
  before_filter :admin_setup  
  
  def admin_setup
    @pictures = Picture.all
    @blog_posts = BlogPost.all
  end
  
  def check_admin
    is_admin?
  end

  def user_all
   User.find(:all)
  end
     
  def index
  end
end
