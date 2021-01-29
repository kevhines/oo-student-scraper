require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = [] #name, location, profile_url
    index_page.css("div.student-card").each do |student|
        students << {
    :name => student.css("h4").first.text,
    :location => student.css("p").first.text,
    :profile_url => student.css("a").first["href"]
        } 
    end  
    students
end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    profile_page.css("div.social-icon-container")[0].css("a").each do |social|
      
      if social["href"].include?("twitter")
         student[:twitter] =  social["href"]
      elsif social["href"].include?("linkedin")
        student[:linkedin] =  social["href"]
      elsif social["href"].include?("github")
        student[:github]  =  social["href"]
      else
        student[:blog]  = social["href"]
      end
    end
    student[:profile_quote] = profile_page.css("div.profile-quote")[0].text 
    student[:bio] = profile_page.css("div.bio-content p")[0].text 
    student
  end

end

