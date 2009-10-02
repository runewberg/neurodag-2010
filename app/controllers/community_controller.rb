class CommunityController < ApplicationController
  helper :profile
  before_filter :protect

  def index
     @users = User.paginate :all, :page => params[:page], :order => 'created_at DESC', :per_page => 10
  end
  
  
  private

  # Return true if the browse form input is valid, false otherwise.
  def valid_input?
    @spec = Spec.new
    # The input is valid iff the errors object is empty.
    @spec.errors.empty?
  end
end