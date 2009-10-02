class SiteController < ApplicationController

  def index
    @title = "#{@@site_name} #{year}"
  end

  def about
    @title = "About #{@@site_name}" 
  end

  def contact
    @title = "Contact #{@@site_name}" 
  end


  def help
    @title = "#{@@site_name} Help"
  end

  def programme
    @title = "Programme #{year}"
  end

  def registration
    @title = "Registration #{year}"
  end

  def competition
    @title = "Competition #{year}"
  end

  def not_found
  end

end
