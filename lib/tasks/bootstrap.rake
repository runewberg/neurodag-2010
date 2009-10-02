namespace :bootstrap do
    desc "Add the default user"
    task :default_users => :environment do
       User.delete_all
       User.create(:screen_name => 'rune', :email => 'rune2earth-admin@gmail.com', :password => 'admin', :role => 'admin', :first_name => 'Rune', :last_name => 'Berg')
       User.create(:screen_name => 'referee', :email => 'rune2earth-ref@gmail.com', :password => 'referee', :role => 'referee', :first_name => 'Referee', :last_name => 'Abcde')
       User.create(:screen_name => 'referee2', :email => 'rune2earth-ref2@gmail.com', :password => 'referee2', :role => 'referee', :first_name => 'Referee', :last_name => 'Bcdef')
       User.create(:screen_name => 'user', :email => 'rune2earth-user@gmail.com', :password => 'user', :role => 'user', :first_name => 'John', :last_name => 'Doe')    
       User.create(:screen_name => 'user2', :email => 'rune2earth-user2@gmail.com', :password => 'user2', :role => 'user', :first_name => 'Sam', :last_name => 'Jones')    
       User.create(:screen_name => 'kris', :email => 'kmandrup@gmail.com', :password => '1234', :role => 'user', :first_name => 'Kristian', :last_name => 'Mandrup')    
    end

    desc "Add the production users"
    task :prod_users => :environment do
       User.delete_all
       User.create(:screen_name => 'rune', :email => 'rune2earth@gmail.com', :password => 'admin47', :role => 'admin', :first_name => 'Rune', :last_name => 'Berg')
       User.create(:screen_name => 'lisbeth', :email => 'lisbeth@gmail.com', :password => 'admin47', :role => 'admin', :first_name => 'Lisbeth', :last_name => 'Causse')
       User.create(:screen_name => 'nicolas', :email => 'nicolas@gmail.com', :password => 'admin47', :role => 'admin', :first_name => 'Nicolas', :last_name => 'Petersen')
       User.create(:screen_name => 'lone', :email => 'lone@gmail.com', :password => 'admin47', :role => 'admin', :first_name => 'Lone', :last_name => 'Helbo')
       User.create(:screen_name => 'christina', :email => 'christina@gmail.com', :password => 'admin47', :role => 'admin', :first_name => 'Christina', :last_name => 'Kruuse')

       User.create(:screen_name => 'jens', :email => 'jens@gmail.com', :password => '1234', :role => 'referee', :first_name => 'Jens', :last_name => 'Rekling')
       User.create(:screen_name => 'malene', :email => 'malene@gmail.com', :password => '1234', :role => 'referee', :first_name => 'Malene', :last_name => 'Flagga')
       User.create(:screen_name => 'morten', :email => 'morten@gmail.com', :password => '1234', :role => 'referee', :first_name => 'Morten', :last_name => 'Møller')

       User.create(:screen_name => 'user', :email => 'rune2earth-user@gmail.com', :password => 'user', :role => 'user', :first_name => 'John', :last_name => 'Doe')    
       User.create(:screen_name => 'user2', :email => 'rune2earth-user2@gmail.com', :password => 'user2', :role => 'user', :first_name => 'Sam', :last_name => 'Jones')    
       User.create(:screen_name => 'user3', :email => 'kmandrup@gmail.com', :password => '1234', :role => 'user', :first_name => 'Kristian', :last_name => 'Mandrup')    
    end

    desc "Create the default conference"
    task :default_conference => :environment do
      Conference.delete_all
      Conference.create(:title => 'Neurodag 2009', :year => Date.parse("2009/11/06"), :venue => 'Copenhagen Biocenter')
    end

    desc "Create the default talks"
    task :default_talks => :environment do
      Talk.delete_all
      Talk.create(:title => 'Talk 1',  :abstract => "My talk 1", :user_id => User.find_by_screen_name('user').id,:conference_id => Conference.first.id )
      Talk.create(:title => 'Talk 2', :abstract => "My talk 2", :user_id => User.find_by_screen_name('user2').id,:conference_id => Conference.first.id )
      Talk.create(:title => 'Talk 2', :abstract => "My talk 2", :user_id => User.find_by_screen_name('user3').id,:conference_id => Conference.first.id )
     end

    desc "Create the default registrations"
    task :default_registrations => :environment do
      Registration.delete_all
      Registration.create(:user_id => User.find_by_screen_name('rune').id, :conference_id => Conference.first.id, :bringing_posters => true)
      Registration.create(:user_id => User.find_by_screen_name('malene').id, :conference_id => Conference.first.id, :bringing_posters => false)
      Registration.create(:user_id => User.find_by_screen_name('christina').id, :conference_id => Conference.first.id, :bringing_posters => false)
      Registration.create(:user_id => User.find_by_screen_name('nicolas').id, :conference_id => Conference.first.id, :bringing_posters => false)
      Registration.create(:user_id => User.find_by_screen_name('lone').id, :conference_id => Conference.first.id, :bringing_posters => false)
      Registration.create(:user_id => User.find_by_screen_name('lisbeth').id, :conference_id => Conference.first.id, :bringing_posters => false)
      Registration.create(:user_id => User.find_by_screen_name('user').id, :conference_id => Conference.first.id, :bringing_posters => false, :participate_competition => true)
      Registration.create(:user_id => User.find_by_screen_name('user2').id, :conference_id => Conference.first.id, :bringing_posters => false, :participate_competition => true)
      Registration.create(:user_id => User.find_by_screen_name('user3').id, :conference_id => Conference.first.id, :bringing_posters => false, :participate_competition => true)
    end

   desc "Create the default posters"
   task :default_posters => :environment do
     Poster.delete_all
     Poster.create(:title => 'Poster 1 ', :abstract => "My talk 1", :user_id => User.find_by_screen_name('user').id, :conference_id => Conference.first.id, :registration_id => Registration.first.id)
     Poster.create(:title => 'Poster 2 ', :abstract => "My talk 1", :user_id => User.find_by_screen_name('user2').id, :conference_id => Conference.first.id, :registration_id => Registration.first.id)
     Poster.create(:title => 'Poster 3 ', :abstract => "My talk 1", :user_id => User.find_by_screen_name('user3').id, :conference_id => Conference.first.id, :registration_id => Registration.first.id)
   end


   desc "Create the default posters"
   task :default_pages => :environment do
    Page.create(:title => 'Home', :conference_id => Conference.first.id )
    Page.create(:title => 'Program', :conference_id => Conference.first.id )
    Page.create(:title => 'Presentation competition', :conference_id => Conference.first.id )
    Page.create(:title => 'Plenary Speakers', :conference_id => Conference.first.id )
    Page.create(:title => 'Venue', :conference_id => Conference.first.id )
    Page.create(:title => 'Funding', :conference_id => Conference.first.id )
   end



    desc "Run all bootstrapping tasks"
    task :all => [:default_users, :default_conference, :default_talks, :default_registrations, :default_posters,:default_pages]

    task :prod => [:prod_users, :default_conference, :default_talks, :default_registrations, :default_posters,:default_pages]
    # brug dette i heroku rake bootstrap:prod
end
  
  
  
  
  
  