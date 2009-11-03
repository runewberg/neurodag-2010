# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

# /usr/local/mysql/bin/mysql_config
# /opt/local/lib/mysql5/
# sudo gem install mysql -- --with-mysql-include=/opt/local/include/mysql5 --with-mysql-lib=/opt/local/lib/mysql5 --with-mysql-config=/opt/local/lib/mysql5/bin/mysql_config
# sudo gem install mysql -- --with-mysql-include=/usr/local/mysql/include/mysql5 --with-mysql-lib=/usr/local/mysql/lib/mysql5 --with-mysql-config=/usr/local/mysql/bin/mysql_config

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "ambethia-smtp-tls", :lib => "smtp-tls", :source => "http://gems.github.com/"  
  #config.gem 'prawn'
  config.gem "scrapi"  
  # config.gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => 'http://gems.github.com'  
  
  config.action_controller.session_store = :active_record_store
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  #RUNE0209 config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  config.action_mailer.smtp_settings = {
    :address        => "smtp.gmail.com",
    :port           => 587,
    :domain         => "neurodag.rberg@gmail.com",
    :authentication => :plain,
    :user_name      => "neurodag.rberg",
    :password       => "eyrzfp4yuspxeyrzfp4yuspx" 
  }  
end

ExceptionNotifier.exception_recipients = %w(neurodag.rberg@gmail.com rune2earth@gmail.com kmandrup@gmail.com)

require 'smtp-tls'
# require 'pdf/writer'  
require 'prawn'
require 'prawn/format'  
require 'nokogiri'

require 'sentry'
Sentry::SymmetricSentry.default_key = "rune_secret_password"

DB_STRING_MAX_LENGTH = 255
DB_TEXT_MAX_LENGTH = 4000
HTML_TEXT_FIELD_SIZE = 15

Time::DATE_FORMATS[:vshort] = "%b/%y"

Time::DATE_FORMATS[:short] = "%d. %b, %y"

Time::DATE_FORMATS[:article] = "%A, %B %d, %Y"

Time::DATE_FORMATS[:no_weekday] = "%B %d, %Y"
  
  if ENV['RAILS_ENV']
     require 'hirb'
     Hirb.enable
  end  

# require 'yaml'
#settings_file = File.join(File.dirname(__FILE__), 'config', 'settings.yml')
#APP_CONFIG = YAML::load(File.open(settings_file)  

APP_CONFIG = { 'app_root' => "neurodag.heroku.com"}

require 'htmlentities'
CODER = HTMLEntities.new
 
require 'string_extensions'  
require "prawn/assist/include"