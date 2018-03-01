require 'open-uri'
require 'nokogiri'

# File.open("lbccontent", 'wb') do |file|
#   file.write(open(url).read)
# end

class LeboncoinScrappingService
  def initialize(attributes = {})
    @name = attributes[:name]
    @version = attributes[:version]
    @location = attributes[:location]
    @brand = attributes[:brand]
  end

  def lbc_iterate_over_result_pages
    i = 1
    # Iterate over each page result while not empty
    loop do
      url = "https://www.leboncoin.fr/annonces/offres/?o=#{i}&q=#{@name.downcase}%20#{@version}&location=#{@location}"
      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      break if !html_doc.xpath('//article[contains(@class, "noResult")]').text.empty? || i > 3
      puts "============================ PAGE #{i} ============================="
      lbc_result_page_scrapper(html_doc)
      i += 1
    end
  end

  def lbc_result_page_scrapper(html_doc)
    # Identify each iPhone with the h2 tag
    html_doc.search('.tabsContent a').each do |element|
      ad_title = element.attribute('title').value
      if ad_title.downcase.start_with?('iphone')

        # Save product_page url
        puts ad_title
        ad_url = "https:#{element.attribute('href').value.split('?')[0]}"
        puts ad_url

        # Retrieve city from product_card
        meta_result = element.search('meta').first
        if meta_result['itemprop'] == 'address'
          ad_location = meta_result['content'].split('/')[0]
          puts ad_location
        end

        # Retrieve price from product_card
        ad_price = 0
        element.search('h3').each do |h3_result|
          if h3_result['itemprop'] == 'price'
            ad_price = h3_result['content'].to_i
          end
        end
        puts "#{ad_price} euros"

        # Open product_page
        product_file = open(ad_url).read
        product_doc = Nokogiri::HTML(product_file)

        # Retrieve date from product_page
        ad_datetime =  DateTime.strptime(product_doc.xpath('//div[@data-qa-id="adview_date"]').text, '%e/%m/%Y à %Hh%M')
        puts ad_datetime

        # Retrieve description (as html string) from product_page
        ad_description = product_doc.xpath('//div[@data-qa-id="adview_description_container"]').css('span').first.inner_html
        puts ad_description

        # Retrieve images url from product_page
        img_div_array = []
        product_doc.xpath('//div[starts-with(@style, "background-image:url")]').each do |res|
          img_div_array << res.attribute('style').value.gsub('background-image:url(', '').gsub(');', '')
        end
        img_div_array.uniq!
        puts img_div_array

        puts "- - - - - - - - - - - - - - - - -"
        puts "Creating product"
        product = Product.find_by(version: @version, capacity: 0, color: 'unknown', brand: @brand)
        ad = Ad.create!(title: ad_title, description: ad_description, url: ad_url, date: ad_datetime, location: ad_location, price: ad_price, source: "leboncoin", product: product)
        img_div_array.each do |pic_url|
          Picture.create!(url: pic_url, ad: ad)
        end
        puts "--------------------------------"
      end
    end
  end
end
