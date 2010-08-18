# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
    include ApplicationHelper
    include SimpleCaptcha::ControllerHelpers
    include ExceptionNotifiable
        
    helper :all # include all helpers, all the time
    protect_from_forgery # :secret  => 'sdasfagagsa' # See ActionController::RequestForgeryProtection for details
        
    # layout 'exploitable'
    layout 'default'
    before_filter :check_authorization
    before_filter :set_user_name
    before_filter :set_recent_blog_entries
    before_filter :set_past_conferences
    before_filter :set_my_registration    
    before_filter :set_my_talk    

#    around_filter :handle_errors

    def set_my_registration
      @my_registration = attend_active_conference?
    end

    def set_my_talk
      @my_talk = my_talk_in_competition
    end

    def set_past_conferences
      past_conferences = Conference.all(:limit => 3, :order => 'year DESC')
      @past_conferences = past_conferences[1..past_conferences.size]
    end


    def set_recent_blog_entries
      @recent_blog_entries = BlogPost.find(:all, :limit => 3, :order => 'updated_at DESC')
    end

    def set_user_name
      if current_user != nil
        @user_name = current_user.name 
      else
        @user_name = nil
        #logger.debug(@user_name)
      end
    end


    # Log a user in by authorization cookie if necessary.
    def check_authorization
      authorization_token = cookies[:authorization_token]
      if authorization_token and not logged_in?
        user = User.find_by_authorization_token(authorization_token)
        user.login!(session) if user
      end
    end

    # Return true if a parameter corresponding to the given symbol was posted.
    def param_posted?(sym)
      request.post? and params[sym]
    end

    # Protect a page from unauthorized access.
    def protect
      logger.debug("PROTECT")
      unless logged_in?
        logger.debug("NOT LOGGED IN")        
        session[:protected_page] = request.request_uri
        flash[:notice] = "<i> Please log in before we can do the action. </i>"
        redirect_to :controller => "users", :action => "login"
        return false
      end
      logger.debug("LOGGED IN")              
    end

    # Paginate item list if present, else call default paginate method.

    def make_profile_vars          
      @faq = @user.faq ||= Faq.new 
    end
    
    
    # def method_missing(methodname, *args)
    #  @methodname = methodname
    #  @args = args
    #  render 'site/404', :status => 404
    # end
    # 
    # def rescue_action_in_public(exception)
    #   # do something based on exception
    #   message = exception.backtrace.join("\n") unless exception
    #   render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
    # end

    # def rescue_action_in_public(exception)
    #   render :template => "shared/error", :layout => "standard", :status => "500"
    # end

    def local_request?
      false
    end

# protected    
# 
#     def log_error(exception) 
#       super(exception)
# 
#       begin
#         ErrorMailer.deliver_snapshot(
#           exception, 
#           clean_backtrace(exception), 
#           @session.instance_variable_get("@data"), 
#           @params, 
#           @request.env)
#       rescue => e
#         logger.error(e)
#       end
#     end

    
  end
