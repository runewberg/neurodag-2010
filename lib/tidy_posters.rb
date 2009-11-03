def tidy_posters(tidy = false)
  posters = Poster.all.reverse
  puts "tidying abstracts for #{posters.size} posters" 
  puts "=========="
  posters.each do |poster|
    puts "tidying abstract for poster: #{poster.title}"
    content = poster.abstract
    if content
      puts "not null"
      if !content.blank?
        puts "not blank, do processing"        
        content.gsub!(/&amp;(.*?);/, '&\1;')        
        content.gsub!(/\s&\s/, '&amp;')        
        content.gsub!(/&lt;/, ' |smaller than| ')                
        if tidy    
          puts "tidying html"
          content = tidy_html(content) 
        end
        # poster.abstract = content
        # poster.save_with_validation(false)
        # if poster.save        
        #   if !poster.errors.empty?  
        #     puts "ERROR"
        #     poster.errors.each_full { |msg| puts msg }
        #     puts "---------------------------"
        #     puts poster.errors.full_messages 
        #     puts "---------------------------"
        #   else
        #     puts "=================="          
        #     puts "saved poster ok"
        #     puts "=================="          
        #   end
        # else
        #   puts "poster could not be saved :("
        # end          
      end
    end
  end
end
# USAGE

# open rails console
# $ cons
# >> require 'tidy_posters'
# ...
# [] (DONE!)