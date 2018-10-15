require_relative "./codehelper/version"
require_relative "./codehelper/cli"
require 'nokogiri'
require 'open-uri'
require 'pry'

module Codehelper 
  attr_accessor :input

  @youtube_basepath = "https://www.youtube.com/results?search_query="
  @stackoverflow_basepath = "https://stackoverflow.com/search?q="

  @@all = []
  
  def self.all
    puts @@all
  end 
  
  def self.call 
    puts "Not sure what to do next? Access online resources to assist with your code."
    search
  end 
  
  def self.search 
    puts "What would you like to search?"
    input = gets.strip.downcase 
    if input != nil 
      puts "Let's check resources on #{input}..." 
    else 
      puts "What would you like to search?"
    end 
    @input = input
    search_urls
    scrape_youtube
    scrape_stackoverflow
    all
  end 
  
  def self.search_urls
    search_param = @input.split(' ').join('+')
    @youtube_query = @youtube_basepath + search_param 
    @stackoverflow_query = @stackoverflow_basepath + search_param 
    puts @youtube_query
    puts @stackoverflow_query
  end 

  def self.scrape_youtube
    @ytlisting = {}
    page = Nokogiri::HTML(open(@youtube_query))
      i = 0 
      while i <= 5
      node_2 = page.css('.yt-lockup-meta')
        node_2.each do |node|
          @ytlisting[:date_posted] = node.css('ul').children.css('li').first.text
        end
      node_1 = page.css('.yt-lockup-title')
        node_1.each do |node|  
          @ytlisting[:title] = node.css('a').attribute('title').value
          video_link = node.css('a').attribute('href').value
          @ytlisting[:link] = "https://www.youtube.com" + video_link
       end
      node_3 = page.css('.yt-lockup-description')
        node_3.each do |node|
          @ytlisting[:description] = node.children.inner_text 
       end 
      @@all << @ytlisting
      i += 1
    end
  end 
    
  def self.scrape_stackoverflow
    @stklisting = {}
    page = Nokogiri::HTML(open(@stackoverflow_query))
    node_1 = page.css('.votes')
     node_1.each do |node|
        @stklisting[:votes] = node.children.text.split.join(" ")
      end
    node_2 = page.css('.result-link h3')
      node_2.each do |node|
        @stklisting[:title] = node.css('a').attribute('title').value
        link = node.css('a').attribute('href').value
        video_link = link.gsub(URI.regexp, '<a href="\0">\0</a>')
        @stklisting[:link] = "https://stackoverflow.com" + video_link
      end
     node_3 = page.css('.excerpt')
       node_3.each do |node|
          @stklisting[:excerpt] = node.children.inner_text.split.join(" ")
        end 
    node_4 = page.css('div.status')
       node_4.each do |node|
         @stklisting[:status] = node.children.text.split.join(" ")
        end 
      @@all << @stklisting

  end 
 
  end