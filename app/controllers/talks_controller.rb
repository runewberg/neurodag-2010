class TalksController < ApplicationController
  layout 'default'
  before_filter :get_talk, :only => [:show, :destroy, :edit, :update]
  before_filter :protect
  
    # GET /talk
    def show      
      @title = @talk.title
      @abstract = @talk.abstract
      @owner = @talk.owner
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @post.to_xml }
      end    
    end


    def pdf
      @talks_all = Talk.all :conditions => ['talks.conference_id = ? AND talks.user_id = users.id',       @active_conference.id], :include => :user, :order => 'users.last_name ASC'
      @most_recent_talk = Talk.most_recent[0]
    end
 
    def index
      @talks = Talk.paginate :all, :page => params[:page], :order => 'created_at DESC'
      @talks_all = Talk.all :conditions => ['talks.conference_id = ? AND talks.user_id = users.id',       @active_conference.id], :include => :user, :order => 'users.last_name ASC'
      @most_recent_talk = Talk.most_recent[0]
      # @talks = Talk.all :order => 'created_at DESC'   
      
      respond_to do |format|
         format.html # index.rhtml
         format.pdf { render :layout => false } # index.pdf.prawn
       end     
    end

    def referee
      #@talks_paginated = Talk.paginate :all, :page => params[:page], :order => 'created_at DESC'
      @talks = Talk.paginate :page => params[:page], :per_page => 5, :order => 'created_at DESC'
      # @talks = Talk.all :order => 'created_at DESC'
    end

    def all_ref_rated
      @talks = Talk.paginate :all, :page => params[:page], :order => 'created_at DESC'      
    end

    # GET /talks
    def your
      @talks = Talk.find_by_user_id(current_user.id)
      @title = "Your talk"
      redirect_to talk_path(@talk) 
    end

    # talk to be rated - params[:id]
    # rating - params[:stars]
    # dimension rated - params[:dimension]
    # who is rating? - current_user
    # html elemenent to update on rate - <div id="talk.id">
    def rate
      @talk = Talk.find(params[:id])      
      dimension = params[:dimension]
      
      @talk.rate(params[:stars], current_user, dimension)
      
      id = "ajaxful-rating-#{!dimension.blank? ? "#{dimension}-" : ""}talk-#{@talk.id}"
      id_avg = "talk-#{@talk.id}-#{dimension}_avg"      
      avg = @talk.rate_average(true, dimension)
      
      logger.debug("RATE ID: #{id} , AVG_id: #{id_avg}")
      logger.debug("NEW AVERAGE: #{avg}")
      
      render :update do |page|
        page.replace_html id, ratings_for(@talk, :wrap => false, :dimension => dimension, :small_stars => true)
        page.replace_html id_avg, avg
        page.visual_effect :highlight, id
      end
    end

    def rate_big
      @talk = Talk.find(params[:id])
      @talk.rate(params[:stars], current_user, params[:dimension])
      id = "ajaxful-rating-#{!params[:dimension].blank? ? "#{params[:dimension]}-" : ""}talk-#{@talk.id}"
      id_avg = "talk-#{@talk.id}-#{dimension}_avg"      
      avg = @talk.rate_average(true, dimension)      
      logger.debug("ID: #{id}")
      
      render :update do |page|
        page.replace_html id, ratings_for(@talk, :wrap => false, :dimension => params[:dimension])
        page.replace_html id_avg, avg        
        page.visual_effect :highlight, id
      end
    end    
    


    # GET /talk/new
    def new
      @talk = Talk.new
      @title = "Add a new talk"
    end

    # POST /talks
    # POST /talks.xml
    def create
      existing_user_talk = @my_talk
      if existing_user_talk
        flash[:notice] = 'You already have a talk registered.'
        redirect_to talk_path(existing_user_talk)
        return
      end        

 #     return if !request.post?      
      
      @talk = Talk.new(params[:talk])   
      respond_to do |format|
      @talk.user = current_user
      @talk.registration = current_user_registration
      @talk.conference = active_conference
        # save created talk and attempt to add it as child of parent talk!
        if @talk.save 
          flash[:notice] = 'talk was successfully created.'
          format.html { redirect_to talk_url(:id => @talk) }
          format.xml  { head :created, :location => talk_url(:id => @talk) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @talk.errors.to_xml }
        end
      end
    end


    # GET /talk/1;edit
    def edit
      @title = "Edit #{@talk.title}"
    end

    # PUT /talks/1
    # PUT /talks/1.xml
    def update
      #return if !request.post?
      
      respond_to do |format|
        if @talk.update_attributes(params[:talk])
          flash[:notice] = 'talk was successfully updated.'
          format.html { redirect_to talk_url(:id => @talk) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @talk.errors.to_xml }
        end
      end        
    end

    # DELETE /talks/1
    # DELETE /talks/1.xml
    def destroy      
      @talk.destroy

      respond_to do |format|
        format.html { redirect_to talks_url }
        format.xml  { head :ok }
      end
    end  

  private
    def get_talk
      if params[:id]
        @talk = Talk.find(params[:id])
      end
    end

  end
