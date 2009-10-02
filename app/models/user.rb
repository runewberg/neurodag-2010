require 'digest/sha1'
class User < ActiveRecord::Base 
  # has_one :spec, :dependent => :destroy
  has_one :faq, :dependent => :destroy
  has_many :blog_posts, :dependent => :destroy
  has_many :pictures, :dependent => :destroy

  apply_simple_captcha
  ajaxful_rater
  generates_crypted :password, :mode => :symmetric
 
  has_attached_file :avatar, :styles => { :medium => "160x200>", :thumb => "20x25>" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml", :path => ":attachment/:id/:style.:extension", :url => 'neurodag_dev2.s3.amazonaws.com'
 
 
  has_many :abstracts,
           :order => "created_at DESC", 
           :dependent => :destroy
          
  has_many :comments, 
           :order => "created_at DESC", 
           :dependent => :destroy
  
  has_many :friends, 
           :through => :friendships,
           :conditions => "status = 'accepted'", 
           :order => :screen_name

  has_many :conferences, 
           :through =>:registrations, 
           :order => :year

  has_many :posters, 
           :order => 'updated_at DESC',
           :dependent => :destroy

  has_many :talks, 
            :order => 'updated_at DESC',
            :dependent => :destroy


  has_many :requested_friends, 
           :through => :friendships, 
           :source => :friend,
           :conditions => "status = 'requested'", 
           :order => :created_at

  has_many :pending_friends, 
           :through => :friendships, 
           :source => :friend,
           :conditions => "status = 'pending'", 
           :order => :created_at
           
   has_many :friendships,  :dependent => :destroy
   has_one :talk, :dependent => :destroy  
   has_many :registrations, :dependent => :destroy  
           
           
  #acts_as_ferret :fields => ['screen_name', 'email'] # but NOT password

  attr_accessor :remember_me #, :avatar_file_name
  attr_accessor :current_password
  
  # attr_accessible :screen_name, :email, :password, :password_confirmation, :captcha, :captcha_key, :role, :first_name, :last_name, :hide_contact_info
  
  # Max & min lengths for all fields 
  SCREEN_NAME_MIN_LENGTH = 4 
  SCREEN_NAME_MAX_LENGTH = 20 
  PASSWORD_MIN_LENGTH = 4 
  PASSWORD_MAX_LENGTH = 40 
  EMAIL_MAX_LENGTH = 50 
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH 
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH 

  # Text box sizes for display in the views 
  SCREEN_NAME_SIZE = 20 
  PASSWORD_SIZE = 10 
  EMAIL_SIZE = 30 

  validates_uniqueness_of :screen_name, :email 
  validates_confirmation_of :password
  validates_length_of :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of :password, :within => PASSWORD_RANGE 
  validates_length_of :email, :maximum => EMAIL_MAX_LENGTH 

  validates_format_of :screen_name, 
                      :with => /^[A-Z0-9_]*$/i, 
                      :message => "must contain only letters, " + 
                                  "numbers, and underscores" 
  validates_format_of :email, 
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i, 
                      :message => "must be a valid email address"

  named_scope :most_recent, :order => 'created_at DESC', :limit => 3
 # generates_crypted :password, :mode => :symmetric

  # Return the full name (first plus last)
  def full_name
    _name = "No name"
    if first_name && !first_name.blank?
      _name = [first_name.humanize, middle_name.humanize, last_name.humanize].join(" ")
    elsif screen_name && !screen_name.blank?
      _name = screen_name      
    end
  end


  def validate
    # Protect against overwriting default thumbnail...
    if %w(default_thumbnail default).include?(screen_name)
      errors.add(:screen_name, "cannot be that, nice try though")
    end
  end

  def admin?
    self.role == 'admin'
  end

  def is_referee?
    self.role == 'referee'
  end
 
  # Log a user in.
  def login!(session)
    session[:user_id] = id
  end
  
  # Log a user out.
  def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end
  
  # Clear the password (typically to suppress its display in a view).
  def clear_password!
    self.password = nil
    self.password_confirmation = nil
    self.current_password = nil
  end
  
  # Remember a user for future login.
  def remember!(cookies)
    cookie_expiration = 10.years.from_now
    cookies[:remember_me] = { :value   => "1",
                              :expires =>  cookie_expiration }
    self.authorization_token =  unique_identifier
    save!
    cookies[:authorization_token] = { :value   => authorization_token,
                                      :expires => cookie_expiration }
  end
  
  # Forget a user's login status.
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  # Return true if the user wants the login status remembered.
  def remember_me?
    remember_me == "1"
  end

  # Return true if the password from params is correct.
  def correct_password?(params)
    current_password = params[:user][:current_password]
    password == current_password
  end

  # Generate messages for password errors.
  def password_errors(params)
    # Use User model's valid? method to generate error messages 
    # for a password mismatch (if any).
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    # The current password is incorrect, so add an error message.
    errors.add(:current_password, "is incorrect")
  end

  # Return a sensible name for the user.
  def name
    screen_name
  end

  private
  
  # Generate a unique identifier for a user.
  def unique_identifier
    Digest::SHA1.hexdigest("#{screen_name}:#{password}")
  end
  
end
