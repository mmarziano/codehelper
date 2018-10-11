# CLI Controller


class Codehelper::CLI 
  
  def call 
    puts "Not sure what to do next? Access online resources to assist with your code."
    search
  end 
  
  def search 
    puts "What would you like to search?"
    input = gets.strip.downcase 
    case input 
    when input != nil 
      puts input 
    end 
  end 
  
  def search_urls(input)
    #Youtube:results?search_query=ruby+scraping
    #StackOverflow:search?q=ruby+scraping
    #GitHub:search?q=ruby+scraping
end 