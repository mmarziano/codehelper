require_relative "./codehelper/version"
require_relative "./codehelper/cli"
require 'nokogiri'
require 'open-uri'

module Codehelper 
  attr_accessor :input

  @youtube_basepath = "https://www.youtube.com/results?search_query="
  @stackoverflow_basepath = "https://stackoverflow.com/search?q="
  @github_basepath = "https://github.com/search?q="


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
    self.search_urls
    self.scrape_youtube
  end 
  
  def self.search_urls
    search_param = @input.split(' ').join('+')
    @youtube_query = @youtube_basepath + search_param 
    @stackoverflow_query = @stackoverflow_basepath + search_param 
    @github_query = @youtube_basepath + search_param 

   # puts @youtube_query
    #puts @stackoverflow_query
    #puts @github_query
  end 

  def self.scrape_youtube
    @listing = {}
    page = Nokogiri::HTML(open(@youtube_query))
    node_2 = page.css('.yt-lockup-meta')
      node_2.each do |node|
        @listing[:date_posted] = node.css('ul').children.css('li').first.text
      end
    node_1 = page.css('.yt-lockup-title')
      node_1.each do |node|  
        @listing[:title] = node.css('a').attribute('title').value
        video_link = node.css('a').attribute('href').value
        @listing[:link] = "https://www.youtube.com" + video_link
      end
    node_3 = page.css('.yt-lockup-description')
      node_3.each do |node|
        @listing[:description] = node.children.inner_text 
      end 
  end 
  
  
  end