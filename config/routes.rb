ActionController::Routing::Routes.draw do |map|
  map.resources :albums
  map.resources :s3_uploads
  map.resources :pictures, :member => {:publish => :get}
  map.resources :blog_posts,  :collection => {:your => :get}
  map.resources :pages
  map.resources :conferences
  map.resources :posters, :member => {:rate => :post}, :collection => {:your => :get, :pdf => :get, :do_prawn => :get}
  map.resources :talks, :member => {:rate => :post}, :collection => {:referee => :get, :all_ref_rated => :get, :pdf => :get}
  map.resources :registrations, :collection => {:pdf => :get}

  # REST resources.
  map.resources :users, :member => {:blog_of => :get}, :collection => {:blogs => :get, :delete_selected => :put, :referee_rated_talks => :get, :referee_avg_rated_talks => :get}  
  
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.home '', :controller => 'site', :action => 'index', :id => nil

  map.admin 'admin', :controller => 'admin', :action => 'index'
  map.referee 'referee', :controller => 'referee', :action => 'index'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Named routes.
  map.search 'search', :controller => 'community', :action => 'search'
  map.browse_all 'browse_all', :controller => 'community', :action => 'browse_all'
  
  map.profile 'profile/:screen_name', :controller => 'profile', :action => 'show'
  map.login 'login', :controller => 'users', :action => 'login'
  map.logout 'logout', :controller => 'users', :action => 'logout'
  
  # community_path
  map.community 'community', :controller => 'community', :action => 'index'    

  # organizers_path
  map.organizers 'organizers', :controller => 'site', :action => 'organizers'    

  # home_path
  map.home 'home', :controller => 'site', :action => 'index'    
  map.about 'about', :controller => 'site', :action => 'about'    
  map.contact 'contact', :controller => 'site', :action => 'contact'    
  map.help 'help', :controller => 'site', :action => 'help'    
  map.how 'how', :controller => 'site', :action => 'how'    
  map.competitioninfo 'competitioninfo', :controller => 'site', :action => 'competitioninfo'    
  
  # programme_path(:year), fx programme_path(2009)
#  map.programme 'programme/:year', :controller => 'site', :action => 'programme', :requirements => {:year => /20\d\d/}    
#  map.registration 'registration/:year', :controller => 'site', :action => 'registration', :requirements => {:year => /20\d\d/}    
#  map.competition 'competition/:year', :controller => 'site', :action => 'competition', :requirements => {:year => /20\d\d/}

# map.error ':controllername',  :controller => 'home',
#                               :action => '404'
# 
# map.connect '*path', :controller => 'site', :action => 'not_found'

  
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  
  
end

