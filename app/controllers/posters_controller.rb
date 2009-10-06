class PostersController < ApplicationController
  layout 'default'
  before_filter :get_poster, :only => [:show, :destroy, :edit, :update]
  before_filter :protect
    # GET /poster
    def show
      @title = @poster.title
      logger.debug(@poster.to_yaml)
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @post.to_xml }
      end    
    end

    def pdf
      @posters_all = Poster.all :conditions => ['posters.conference_id = ? AND posters.user_id = users.id',       @active_conference.id], :include => :user, :order => 'users.last_name ASC'
      @most_recent_poster = Poster.most_recent[0]
    end

    def do_prawn
      respond_to do |format|
        format.html # index.rhtml
        format.pdf { render :layout => false }  # do_prawn.pdf.prawn
      end          
    end


    def index
      #@posters = Poster.find(:all)
      @posters = Poster.paginate :page => params[:page], :per_page => 15, :order => 'id DESC'
      @posters_all = Poster.all :conditions => ['posters.conference_id = ? AND posters.user_id = users.id',       @active_conference.id], :include => :user, :order => 'users.last_name ASC'
      most_recent_poster = Poster.most_recent[0]

      respond_to do |format|
        format.html # index.rhtml
        format.pdf { render :layout => false } # index.pdf.prawn
      end    
    end
         

    # talk to be rated - params[:id]
     # rating - params[:stars]
     # dimension rated - params[:dimension]
     # who is rating? - current_user
     # html elemenent to update on rate - <div id="talk.id">
     def rate
       @poster = Poster.find(params[:id])      
       dimension = params[:dimension]

       @poster.rate(params[:stars], current_user, dimension)

       id = "ajaxful-rating-#{!dimension.blank? ? "#{dimension}-" : ""}poster-#{@poster.id}"
       id_avg = "poster-#{@poster.id}-#{dimension}_avg"      
       avg = @poster.rate_average(true, dimension)

       render :update do |page|
         page.replace_html id, ratings_for(@poster, :wrap => false, :dimension => dimension, :small_stars => true)
         page.replace_html id_avg, avg
         page.visual_effect :highlight, id
       end
     end

    # GET /posters
    def your
      @posters = Poster.find_all_by_user_id(current_user.id)
      @title = "Your posters"
    end

    # GET /poster/new
    def new
      @poster = Poster.new
      @title = "Add a new poster"
    end

    # POST /posters
    # POST /posters.xml
    def create
      @poster = Poster.new(params[:poster])   
      
     # return if !request.post?
      
      @poster.user = current_user
      @poster.registration = current_user_registration
      @poster.conference = active_conference
      
      respond_to do |format|
        # save created poster and attempt to add it as child of parent poster!
        if @poster.save 
          flash[:notice] = 'poster was successfully created.'
          format.html { redirect_to poster_url(:id => @poster) }
          format.xml  { head :created, :location => poster_url(:id => @poster) }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @poster.errors.to_xml }
        end
      end
    end


    # GET /poster/1;edit
    def edit
      @title = "Edit #{@poster.title}"
    end

    # PUT /posters/1
    # PUT /posters/1.xml
    def update
      
      #return if !request.post?
      #redirect_to :action => "index" unless request.post?
            
      respond_to do |format|
        if @poster.update_attributes(params[:poster])
          flash[:notice] = 'poster was successfully updated.'
          format.html { redirect_to poster_url(:id => @poster) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @poster.errors.to_xml }
        end
      end        
    end

    # DELETE /posters/1
    # DELETE /posters/1.xml
    def destroy      
      @poster.destroy

      respond_to do |format|
        format.html { redirect_to posters_url }
        format.xml  { head :ok }
      end
    end  

  private
    def get_poster
      @poster = Poster.find(params[:id])
    end

  end
