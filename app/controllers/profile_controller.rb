class ProfileController < ApplicationController
  helper :friendship
  before_filter :protect

  def index
    @title = "Neurodag Members"
  end

  def show
    @hide_edit_links = true
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(screen_name)
    if @user
      @title = "My #{@@site_name} Profile for #{screen_name}"
      #@spec = @user.spec ||= Spec.new
      @faq = @user.faq ||= Faq.new
      make_profile_vars
    else
      flash[:notice] = "No user #{screen_name} at Neurodag!"
      redirect_to :action => "index"
    end
    @posters = @user.posters
    # paginate posts 
    # @posts = Post.paginate 
  end
end