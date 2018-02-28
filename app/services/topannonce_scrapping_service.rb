require 'open-uri'
require 'nokogiri'

class TopannonceScrapping

  def initialize(attributes = {})
    @name = attributes[:name]
    @version = attributes[:version]
    @location = attributes[:location]
  end

  def topannonce_iterate_over_result_pages
    #url = "http://www.topannonces.fr/annonces-telephone-occasion-u235.html"
    pages = [1,2,3,4,5]
    urls = []
    pages.each do |page|
      urls << "http://noamsay.odns.fr/lewagon/topannonce/topannonce-p#{page}.html"
    end

    urls.each do |url|
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      topannonce_page_scrapper(html_doc)
    end
  end

  def topannonce_page_scrapper(html_doc)
      ads_array = []
      html_doc.search('.spanbloc').each do |element|
        title = element.search('.annonce-title').first.text.strip
        localite = element.search('.localite').first.text.strip
        city = localite.gsub(/[^a-zA-Z]/,'').to_s
        zipcode = localite.gsub(/\D/, '')
        description = element.search('.detail').first.text.strip
        link = element.css('annonce-title a').map { |link| link['href'] }
        pic = Picture.new(url: element.at('img')['src'])
        price = element.search('.price').first.text.strip
        ads_array << Ad.new(title: title, city: city, zipcode: zipcode, price: price, description: description, picture: pic)
      end
    return ads_array
  end

end # end class
