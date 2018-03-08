require 'open-uri'
require 'nokogiri'

class VivastreetScrappingService
  def initialize(attributes = {})
    @name = attributes[:name]
    @version = attributes[:version]
    @location = attributes[:location]
    @brand = attributes[:brand]
  end

  def results_page_iterator
    i = 1
    # Iterate over each page result while not empty
    loop do
      url = "http://www.vivastreet.com/achat-vente-portables-mobile/paris/q+#{i}/iphone"
      puts url
      begin
        html_doc = Nokogiri::HTML(open(url).read)
        break if i > 3 #!html_doc.xpath('//article[contains(@class, "noResult")]').text.empty? || i > 4
        puts "============================ PAGE #{i} ============================="
        ads_list_crawler(html_doc)
      rescue => e
        puts e
      end
      i += 1
    end
  end

  def ads_list_crawler(html_doc)
    html_doc.search('a').each do |link|
      if (/http:\/\/www.vivastreet.com\/achat-vente-portables-mobile\/.*\/(iphone|apple).*\/\d+/).match?(link.attribute('href'))
        puts "======================================="
        ad_url = link.attribute('href')
        puts ad_url

        # if Ad.find_by(url: ad_url).nil?
        #   puts "+++ Creating new ad +++"
        #   begin
        #     ad_page_scrapper(ad_url)
        #   rescue => e
        #     puts e
        #   end
        # else
        #   puts "--- Ad already exists ---"
        # end

      else
          puts "#{ad_url} => NOT AN IPHONE"
      end
    end
  end

  def ad_page_scrapper(ad_url)
    #sleep(rand(0.0..3.0))
    # Open ad_page
    ad_doc = Nokogiri::HTML(open(ad_url).read)

    # # Retrieve title from ad_page
    # ad_title = ad_doc.search("h1.no-border").children.first.content.gsub("\n",'').gsub("\t",'').rstrip
    # puts ad_title
    # #return if !ad_title.downcase.start_with?('iphone') #|| !ad_title.downcase.start_with?('vend iphone') || !ad_title.downcase.start_with?('vends iphone')

    # # Retrieve ad_price from ad_page
    # ad_price = ad_doc.search("h2.item_price").attribute("content").value.to_i
    # (/\d+€/).match?()
    # puts ad_price
    # # Retrieve location from ad_page
    # ad_location = ad_doc.xpath("//span[@itemprop = 'address']").children.first.text.gsub("\n", '').rstrip
    # puts ad_location
    # Retrieve date from ad_page
    # ad_datetime = DateTime.strptime(ad_doc.xpath("//p[@itemprop = 'availabilityStarts']").attribute('content').value, '%Y-%m-%d')
    # puts ad_datetime
    # Retrieve description (as html string) from ad_page
    ad_description = ad_doc.search('.shortdescription')
    if ad_description.nil?
      ad_description = ""
    else
      ad_description = ad_description.inner_html
    end
    puts ad_description

#     # Retrieve images url from ad_page
#     img_div_array = ad_doc.search("script").text.scan(/https:\/\/img\d.leboncoin.fr\/ad-large\/[a-z0-9]*.jpg/)
#     puts img_div_array
#     # Find corresponding product and return new ad
#     product = Product.find_by(version: @version, capacity: 0, color: 'unknown', brand: @brand)
#     ad = Ad.new(title: ad_title, description: ad_description, url: ad_url, date: ad_datetime, location: ad_location, price: ad_price, source: "leboncoin", product: product)
# #    compare_ad_to_database(ad, img_div_array)

#     ad.save
#     if !img_div_array.nil?
#       img_div_array.each { |pic_url| Picture.create!(url: pic_url, ad: ad) }
#     end
  end

  # def compare_ad_to_database(ad, img_div_array)

  # end
end

#VivastreetScrappingService.new(name: 'iPhone', version: "8", location: 'Paris', brand: "Apple").ad_page_scrapper("http://www.vivastreet.com/achat-vente-portables-mobile/paris-17eme-ardt-75017/iphone-5c-16go-debloque---garantie---facture/171014693") #.results_page_iterator
