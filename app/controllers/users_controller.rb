class UsersController < ApplicationController
  include ApplicationHelper
  helper :profile
  before_filter :protect, :only => [:index, :edit]
  
  def referee_rated_talks
    page = params[:page]
    @users = User.paginate :all, :page => page, :per_page => 1, :order => 'created_at DESC', :conditions => "users.role = 'referee' "
    index = page || 1
    all_users = User.all :order => 'created_at DESC', :conditions => "users.role = 'referee' "
    @user = all_users[index.to_i-1]
    return if !@user.is_referee? 
    @title ="Referee #{@user.full_name}:: rated talks "  
    # @ref_rated_talks = Rate.find_all_by_rateable_type_and_user_id('Talk', 2)    
    @ref_talks = Talk.find_rated_by(current_user)  
    @ref_talks.compact!
    
    @ref_talks_research = @ref_talks.sort do |t2, t1|
      t1.stars_by(@user, :research)  <=> t2.stars_by(@user, :research)
    end

    @ref_talks_presentation_style = @ref_talks.sort do |t2, t1|
      t1.stars_by(@user, :presentation_style)  <=> t2.stars_by(@user, :presentation_style)
    end
    
    @ref_talks_organization = @ref_talks.sort do |t2, t1|
      t1.stars_by(@user, :organization)  <=> t2.stars_by(@user, :organization)
    end    
  end

  def referee_avg_rated_talks
    logger.debug "!!! referee_avg_rated_talks"
    @title ="Referees:: Average for rated talks "  
    
    # get all talks
    @ref_talks = Talk.all
    
    # get all referees
    referees = User.all :order => 'created_at DESC', :conditions => "users.role = 'referee' "    
    
    # reject talk if bot rated by all referees
    @ref_talks.reject!{|talk| talk.raters.size != referees.size}    
    @ref_talks.compact!

    logger.debug @ref_talks_research
    @ref_talks_research = @ref_talks.sort do |t2, t1|
      t1.rate_average(false, :research)  <=> t2.rate_average(false, :research)
    end

    @ref_talks_presentation_style = @ref_talks.sort do |t2, t1|
      t1.rate_average(false, :presentation_style)  <=> t2.rate_average(false, :presentation_style)
    end
    
    @ref_talks_organization = @ref_talks.sort do |t2, t1|
      t1.rate_average(false, :organization)  <=> t2.rate_average(false, :organization)
    end    
    
  end
  
  def show
    @title = "Neurodag User Hub"
    @user = User.find(session[:user_id])
    make_profile_vars
  end

  def index
     @title = "Neurodag Members"
     order = params[:order]
     logger.debug("ORDER #{order}")
     @users = User.paginate :all, :page => params[:page], :order => 'created_at DESC', :per_page => 13     
   end

  def blog_of
    @user = User.find(params[:id])
    if @user
      @title = "Blog posts of #{@user.full_name}"    
      @blog_posts = BlogPost.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC', 
                    :conditions => ['user_id = ? AND conference_id = ?', @user.id, active_conference] #, :include => :comments
    else
        redirect_to blog_posts_path
    end 
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @blog_posts.to_xml }
    end
  end

  def blogs
     @title = "Blogs of "
     @blog_users = User.paginate :all, :page => params[:page], :order => 'blog_posts.updated_at DESC', :per_page => 13,
                   :conditions => ['users.id = blog_posts.user_id' ], :include => :blog_posts
    
     @blog_users.reject!{|u| u.blog_posts.count == 0}
  end

  def delete_selected
    delete_user_ids = params[:del_user]
    logger.debug(delete_user_ids)
    if is_admin?
      delete_user_ids.each do |id|
         u = User.find(id)
         u.registrations.delete_all
         u.posters.delete_all
         u.blog_posts.delete_all
         u.talks.delete_all
         u.destroy
      end
      # User.delete(delete_user_ids)
    end
    redirect_to :action => "index"
  end

  def new
    flash[:notice] = nil
    @title = "Register"
    @user = User.new
    if param_posted?(:user)
      @user = User.new(params[:user])
      @user.screen_name = params[:user][:screen_name].downcase
      @user.save_with_captcha
      if @user.errors.empty? 
        @user.login!(session)
        flash[:notice] = "User #{@user.screen_name} created!"
        redirect_to_forwarding_url
      else
        @user.clear_password!
      end
    end
  end


  def login
    @title = "Log in to #{@@site_name}"
    @user = User.new
    if request.get?    
      @user = User.new(:remember_me => remember_me_string)
    elsif param_posted?(:user)
      # create virtual user using credentials received from login page
      @user = User.new(params[:user])
      # find real user matching screen name
      user = User.find_by_screen_name(@user.screen_name.downcase) 
      # comapre passwords of virtual and real user
      if @user.password == user.password
        # if match, do login
        user.login!(session)
        @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
        flash[:notice] = "User #{user.screen_name} logged in!"
        redirect_to_forwarding_url
      else 
        # if not, clear password, redirect back to login
        @user.clear_password!
        flash[:notice] = "Invalid screen name/password combination"
      end
    end
  end
  
  def logout
    User.logout!(session, cookies)
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to :action => "index", :controller => "site"
  end
  
  def update
    # return if !request.post?    
    @user = User.find(params[:id])
    @user.screen_name = params[:user][:screen_name].downcase    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => "show"  
    else
      flash[:notice] = 'User was not updated.'
      redirect_to :action => "edit"  
    end
    # render :update do |page|
    #   page.replace_html 'notice', flash[:notice]
    #   page.visual_effect :highlight, 'notice'
    # end
    
  end
  
  # Edit the user's basic info.
  def edit
    logger.debug("USER EDIT")
    @title = "Edit basic info"
    @user = User.find(session[:user_id])   
    # For security purposes, never fill in password fields.
    @user.clear_password!
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      User.logout!(session, cookies)
      flash[:notice] = "Logged out"
      @user.destroy
    end    
    redirect_to :action => "index", :controller => "site"
  end

  private
  
  # Redirect to the previously requested URL (if present).
  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :action => "show"
    end
  end
  
  # Return a string with the status of the remember me checkbox.
  def remember_me_string
    cookies[:remember_me] || "0"
  end
  
  # Try to update the user, redirecting if successful.
  def try_to_update(user, attribute)
    if user.update_attributes(params[:user])
      flash[:notice] = "User #{attribute} updated."
      redirect_to :action => "show"
    end
  end
end