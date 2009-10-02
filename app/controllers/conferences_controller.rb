class ConferencesController < ApplicationController
  
  @@initial_conf_pages = ['Home','Program','Presentation competition',
    'Plenary Speakers','Venue', 'Funding']
    
  def index
    @conferences = Conference.all :include => :pages
  end

  def show
    @year = year
    @title = "#{@@site_name} #{@year}"
    @id = params[:id]
    if (@id)
      @conference = Conference.find_by_id(@id)
      
      set_sidebar_conference(@conference)    
      
      @pages = @conference.pages
    end
  end
  
  def set_sidebar_conference(conf)
    session[:sidebar_conference] = conf
  end    
  
  # GET /page/new
   def new
     @conference = Conference.new
     @title = "Add a new conference"
   end

   # POST /pages
   # POST /pages.xml
   def create
     @conference = Conference.new(params[:conference])    
     
    # return if !request.post?
           
     respond_to do |format|
        if @conference.save  
         flash[:notice] = 'Conference was successfully created.'
         
         @@initial_conf_pages.each do |page_title|
           new_page=Page.create(:title => page_title)
           @conference.pages << new_page
         end         
         
         format.html { redirect_to conference_url(:id => @conference) }
         format.xml  { head :created, :location => conference_url(:id => @conference) }
       else
         format.html { render :action => "new" }
         format.xml  { render :xml => @conference.errors.to_xml }
       end
     end
   end


   # GET /page/1;edit
   def edit
     @conference = Conference.find(params[:id])
     @title = "Edit #{@conference.title}"
   end

   # PUT /pages/1
   # PUT /pages/1.xml
   def update
     @conference = Conference.find(params[:id]) 
     
    # return if !request.post?
              
     respond_to do |format|
       if @conference.update_attributes(params[:conference])
         flash[:notice] = 'Conference was successfully updated.'
         format.html { redirect_to conference_url(:id => @conference) }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @conference.errors.to_xml }
       end
     end        
   end

   # DELETE /pages/1
   # DELETE /pages/1.xml
   def destroy
     @conference = Conference.find(params[:id])
     @conference.destroy

     respond_to do |format|
       format.html { redirect_to conferences_url }
       format.xml  { head :ok }
     end
   end  
  
   
end
