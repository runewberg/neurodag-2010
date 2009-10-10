class CommentsController < ApplicationController 
  helper :profile
  include ProfileHelper 
  before_filter :protect, :load_post 
  
  def new 
    @comment = Comment.new 
  
    respond_to do |format|
      format.html # new.rhtml
      format.js # new.rjs 
    end 
  end
  
  def create 
    @comment = Comment.new(params[:comment]) 
    @comment.user = current_user

    # add comment to comments list for blog_post
    @blog_post.comments << @comment

    # always redirect back to show page for blog_post (display errors or blog_post with new comment)
    respond_to do |format| 
      format.html { redirect_to blog_post_path(@blog_post) }
    end 
  end
  
  def destroy 
    @comment = Comment.find(params[:id]) 
    user = User.find(session[:user_id]) 
    
    if @comment.authorized?(user) 
      @comment.destroy 
    else 
      redirect_to hub_url 
      return 
    end 
  
    respond_to do |format| 
      format.js # destroy.rjs 
    end
  end

  private 

  def load_post 
    @blog_post = BlogPost.find(params[:post_id]) 
  end 
end