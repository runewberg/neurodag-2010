class BlogPostsController < ApplicationController
  helper :profile
  before_filter :protect
    
  def index
    @title = "All blog posts"
    @blog_posts = BlogPost.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @blog_posts.to_xml }
    end
  end

  # find all your blog posts for active conf
  def your
    @blog_post = BlogPost.new    
    @title = "Your blog posts"
    @blog_posts = BlogPost.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC', 
                  :conditions => ['user_id = ? AND conference_id = ?', current_user, active_conference] #, :include => :comments
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @blog_posts.to_xml }
    end
  end


  def show
    @blog_post = BlogPost.find(params[:id])
    @title = @blog_post.title 
    @comment = Comment.new   
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @post.to_xml }
    end
  end

  # GET /posts/1;edit
  def edit
    @blog_post = BlogPost.find(params[:id])
    @title = "Edit #{@blog_post.title}"
  end

  def new
    logger.debug("Blog post NEW")
  end

  # POST /posts
  # POST /posts.xml
  def create
    @blog_post = BlogPost.new(params[:blog_post])
    if current_user
      logger.debug("USER :" + current_user.full_name)
      @blog_post.user = current_user
      @blog_post.conference = active_conference    
    else
      redirect_to blog_posts_path
      return
    end
  #  return if !request.post?
    error = false
    logger.debug("BLOG POST CREATE")
    respond_to do |format|
      if !@blog_post.duplicate? 
        if @blog_post.save
          flash[:notice] = 'Blog post was successfully created.'
          format.html { redirect_to your_blog_posts_path }
          format.xml  { head :created, :location => blog_post_path(@blog_post) }
        else
          error = true
        end
      else
        flash[:notice] = 'This blog post is a duplicate of a previous blog'
        error = true                  
      end
      if error
        @blog_posts = BlogPost.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC', 
                      :conditions => ['user_id = ? AND conference_id = ?', current_user, active_conference] #, :include => :comments        
        format.html { render :action => "your" }
        format.xml  { render :xml => @blog_post.errors.to_xml }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @blog_post = BlogPost.find(params[:id])

 #   return if !request.post?
    
    respond_to do |format|
      if @blog_post.update_attributes(params[:blog_post])
        flash[:notice] = 'Blog post was successfully updated.'
        format.html { redirect_to blog_post_path(@blog_post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog_post.errors.to_xml }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @blog_post = BlogPost.find(params[:id])
    @blog_post.destroy

    respond_to do |format|
      format.html { redirect_to blog_posts_path }
      format.xml  { head :ok }
    end
  end

end