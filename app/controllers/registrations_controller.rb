class RegistrationsController < ApplicationController
  @@error_msg = 'Registration was NOT successful, please try again!'
  @@success_msg = 'Registration was successful'
  before_filter :protect
  
  def show
    @user = current_user
    @attend = "No"
    @attend = "Yes" if attend_active_conference?
    @registration = Registration.find(params[:id])    
    @is_in_competition = participate_competition_text
    @bringing_posters = bringing_posters_text
    logger.debug(@registration.to_yaml)
    logger.debug("payment status: #{@registration.payment_status_txt}")
    @payment_received =  @registration.payment_status_txt
  end

  def pdf
    @attendees_all = Registration.all :conditions => ['registrations.conference_id = ? AND registrations.user_id = users.id',       @active_conference.id], :include => :user, :order => 'users.last_name ASC'
    @most_recent_registration = Registration.most_recent[0]
  end

  def index
    @attendees = Registration.paginate_all_by_conference_id(@active_conference.id, 
                    :conditions => 'user_id IS NOT NULL',
                    :include => :user, :page => params[:page], :per_page => 8, 
                    :order => 'users.last_name ASC')
     @attendees_all = Registration.all :conditions => ['registrations.conference_id = ? AND registrations.user_id = users.id',       @active_conference.id], :include => :user, :order => 'users.last_name ASC'
     @most_recent_registration = Registration.most_recent[0]
    @title = "People attending :: " + @active_conference.title
    respond_to do |format|
       format.html # index.rhtml
       format.pdf { render :layout => false } # index.pdf.prawn
     end    
    
  end

  def new
    @posters = ['', '', '']    
    @registration = Registration.new
    @title = "Registration for the meeting"    
  end

  def personal
    if attend_active_conference?
      redirect_to edit_registration_path    
    else
      redirect_to new_registration_path
    end    
  end

  def create    
    logger.debug("CREATE REG")    
   # return if !request.post?
        
    current_user_registration = Registration.find_by_user_id(current_user.id)
    if !current_user_registration
      current_user.conferences << active_conference
      flash[:notice] = "You are now registered for the neurodag conference "
    else
      flash[:notice] = "You are already registered."
    end
    redirect_to registration_path(current_user.registrations.first.id)    
  end

  def destroy
    logger.debug("DESTROY REG")
    current_user_registration = Registration.find_by_user_id(current_user.id)
     if current_user_registration
       current_user.conferences.delete(active_conference)
       flash[:notice] = "You have been unregistered."
     else
       flash[:notice] = "You are have already been unregistered."
     end
     redirect_to registrations_path    
  end

  def edit
    compete = compete_in_active_conference?
    posters = bringing_posters?
    
    logger.debug("COMPETE #{compete}, POSTERS #{posters}")
    
    @is_in_competition = participate_competition_text
    @bringing_posters = bringing_posters_text
    @registration = Registration.find(params[:id])
    @title = "Edit Registration"
  end

  
  def update
    @registration = Registration.find(params[:id])
    preg = params[:registration]
    logger.debug(preg)
    pay_status = preg[:payment_status]
    
  #  if request.post?
        
    if pay_status
      preg[:payment_status] = text_to_bool(pay_status) 
    end

    @registration.update_attributes(preg)
    if @registration.save
      flash[:notice] = @@success_msg
    else
      flash[:notice] = @@error_msg        
    end     

    if pay_status
      render :update do |page|
        page.replace_html 'notice', flash[:notice]
        page.visual_effect :highlight, 'notice'
      end      
    end
   # end
         
    redirect_to registration_path(current_user.registrations.first.id)        
    # render :action => "edit"           
  end
    
end
