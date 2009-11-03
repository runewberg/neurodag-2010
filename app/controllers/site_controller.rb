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

  def posters
    respond_to do |format|
       format.pdf { render :file   => File.join(Rails.root, 'public', 'posters1.pdf')    } # index.pdf.prawn
     end     
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
