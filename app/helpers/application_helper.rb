module ApplicationHelper
  require 'string'
  require 'object'

  @@site_name = 'Neurodag'
  @@years = 2005..2009
  @@competition_deadline = 'October 16th, 2009'
  @@conferenceregistration_deadline = 'October 30th, 2009'

  def app_root
    "http://" + APP_CONFIG['app_root']
  end

  def truncate_spec(loc)
    loc.gsub!(/science/i, "sci.")
    loc.gsub!(/doctor/i, "dr.")
    loc.gsub!(/medical/i, "Med.")
    loc.gsub!(/\sfor\s/i, " ")
    loc.gsub!(/hospital/i, "Hosp.")
    loc.gsub!(/institute/i, "Inst.")
    loc.gsub!(/institut/i, "Inst.")
    loc.gsub!(/research/i, "Res.")
    loc.gsub!(/laboratory/i, "Lab.")
    loc.gsub!(/laboratorium/i, "Lab.")
    loc.gsub!(/København/i, "KBH.")
    loc.gsub!(/neurobiology/i, "Neurobio.")
    loc.gsub!(/department/i, "Dep.")
    loc.gsub!(/psychology/i, "Psych.")
    loc.gsub!(/associate/i, "Ass.")
    loc.gsub!(/university/i, "U.")
    loc.gsub!(/copenhagen/i, "Cph.")
    loc.gsub!(/student/i, "stud.")
    loc.gsub!(/studerende/i, "stud.")
    loc.gsub!(/professor/i, "prof.")
    loc.gsub!(/technician/i, "tech.")
    truncate(loc,19)
  end


  def full_name
    if current_user 
      current_user.full_name
    else
      "Unknown"
    end
  end

  def strip(html, length = 30)
    truncate(html.gsub(/<\/?[^>]*>/, ""), length)
  end 

  def date_format(date)
    if date
      date.to_s(:vshort)
    else
      ""
    end
  end


  def role_name
    if is_special_role?
      current_user.role.humanize
    else
      ""
    end
  end

  
  def full_name_role
    r = role_name
    role = "(#{role_name})" if r != "" 
    "#{full_name} #{role}" 
  end

  def user_count
    User.all.size
  end

  def blog_count
    Blog.all.size
  end	

  def page_count
    Page.all.size
  end	
          
  def conferenceregistration_deadline
    @@conferenceregistration_deadline
  end        

  def competition_deadline
    @@competition_deadline
  end        
          
  def attend_active_conference?
      current_user_registration
  end

  def current_user_registration
      Registration.find_by_user_id_and_conference_id(current_user , active_conference)
  end

  def sidebar_conference
    session[:sidebar_conference]
  end

  def is_referee?
    current_user && (current_user.role == 'referee')
  end

  def is_admin?
    current_user && (current_user.role == 'admin')
  end

  def is_special_role? 
    is_admin? || is_referee?
  end

  def year
    # extract year from route url (see routes.rb), use last year if no year in route url and year is not included in year list    
    _year = params[:year] || current_year
    @@years.last unless @@years.include?(_year)
  end  
  
  def registered_with_posters?
    reg = attend_active_conference?
    if reg
      Poster.find_by_registration_id(reg.id) != nil      
    else
      nil
    end
  end
  
  def active_conference
    @active_conference ||= Conference.find(:first, :order => 'year DESC')
    flash[:notice] = "There are currently no active conference" unless @active_conference   
    @active_conference
  end
  

  def bool_text(value)
    value ? "Yes" : "No"
  end

  def text_to_bool(text)
    text.downcase == "yes"
  end
  
  def participate_competition_text
    bool_text(compete_in_active_conference?)
  end  

  def my_talk_in_competition
    Talk.find_by_user_id_and_conference_id(current_user, active_conference)
  end

  def compete_in_active_conference?
    reg = attend_active_conference?
    if reg
      reg.participate_competition
    else
      nil
    end
  end
  
  #---------
  
  def bringing_posters_text
    bool_text(bringing_posters?)
  end
  
  def bringing_posters?
    reg = attend_active_conference?
    if reg
      reg.bringing_posters
    else
      false
    end
  end  


  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => capture(&block))
    concat(render(:partial => partial_name, :locals => options), block.binding)
  end

  def post_block(title, options = {}, &block)
    block_to_partial('shared/post_content', options.merge(:title => title), &block)
  end

  def page_block(title, options = {}, &block)
    block_to_partial('shared/page_content', options.merge(:title => title), &block)
  end


  def current_year
    Time.now.strftime('%Y')
  end
  
  # Return a link for use in site navigation.
  def nav_link(text, controller, action="index")
    link_to_unless_current text, :id => nil,
                                 :action => action,
                                 :controller => controller
  end
  
  def sidebar_link(text, controller, action="index")
    nav_link(text, controller, action="index")
  end

  def menu_item(text, link)
    content_tag :li, link_to(text, link)
  end

  def current_user    
      id = session[:user_id]
      if id != nil && id.to_i > 0
        User.find(id)   
      else
        nil
      end
    rescue
      nil
  end 

  # Return true if some user is logged in, false otherwise.
  def logged_in?
    not session[:user_id].nil?
  end
  
  def text_field_for(form, field, 
                     size=HTML_TEXT_FIELD_SIZE, 
                     maxlength=DB_STRING_MAX_LENGTH)
    label = content_tag("label", "#{field.humanize}:", :for => field)
    form_field = form.text_field field, :size => size, :maxlength => maxlength
    content_tag("div", "#{label} #{form_field}", :class => "form_row")
  end
  
  # Return true if results should be paginated.
  # def paginated?
  #   @pages and @pages.length > 1
  # end

  def use_tinymce
      @content_for_tinymce = "" 
      content_for :tinymce do
        javascript_include_tag "tiny_mce/tiny_mce"
      end
      @content_for_tinymce_init = "" 
      content_for :tinymce_init do
        javascript_include_tag "mce_editor"
      end
  end

end 


