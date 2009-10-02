class PagesController < ApplicationController
  before_filter :get_pages, :except => [:new, :create, :index]

  # GET /page
  def show
    @title = @page.title
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @post.to_xml }
    end    
  end
  
  
  # GET /pages
  def index
    @pages = Page.paginate :page => params[:page], :per_page => 20, :order => 'created_at DESC'
    @title = "Pages"

    respond_to do |format|
      format.html # index.rhtml
    end
  end

  # GET /page/new
  def new
    @page = Page.new
    @parent_page_id = params[:page]
    @conference_id = params[:conference_id]
    @title = "Add a new page"
  end

  # POST /pages
  # POST /pages.xml
  def create    
   # return if !request.post?    
    @page = Page.new(params[:page])   
    parent_id = params[:parent_id]

    # find parent or conference for page
    if parent_id != ""
      @parent_page = Page.find(parent_id)
    else
      conf_id = active_conference
      @conference = Conference.find(conf_id)
    end 

    respond_to do |format|
      if @page.save 
        # logger.debug("Page saved")
        flash[:notice] = 'Page was successfully created.'            
        if @parent_page
          # logger.debug("Adding page to parent")                
          @parent_page.children << @page
        else
          # logger.debug("Adding page to conference")
          # logger.debug(@conference.to_yaml)                        
          @conference.pages << @page
        end
        # save created page and attempt to add it as child of parent page!
        format.html { redirect_to page_path(@page) }
        format.xml  { head :created, :location => page_path(@page) }        
      else
        # logger.debug("Errors")      
        # logger.debug(@page.errors.to_yaml)                                        
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  rescue
    logger.debug("RESCUED")                            
    flash[:notice] = 'Error creating page.'          
    render :action => "new"    
  end


  # GET /page/1;edit
  def edit
    @title = "Edit #{@page.title}"
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    # return if !request.post?        
    respond_to do |format|
      if @page.update_attributes(params[:page]) 
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to page_path(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors.to_xml }
      end
    end        
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.xml  { head :ok }
    end
  end  

private
  def get_pages
    @page = Page.find(params[:id])
    # find alle ancestors (parents)
    # @ancestors = @page.ancestors
  end
  
end
