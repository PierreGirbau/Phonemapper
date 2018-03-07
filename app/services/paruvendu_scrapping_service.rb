require 'open-uri'
require 'nokogiri'

class ParuvenduScrappingService
  def initialize(attributes = {})
    @name = attributes[:name]
    @version = attributes[:version]
    @location = attributes[:location]
    @brand = attributes[:brand]
  end

  def results_page_iterator
    sleep(rand(0.0..3.0))
    i = 1
    # Iterate over each page result while not empty
    loop do
      url = "https://www.paruvendu.fr/mondebarras/listefo/default/default/?fulltext=#{@name}&p=#{i}"
      puts url
      html_doc = Nokogiri::HTML(open(url).read)
      break if html_doc.xpath('//li[@class="annonce"]').nil? || i > 3
      puts "============================ PAGE #{i} ============================="
      ads_list_crawler(html_doc)
      i += 1
    end
  end

  def ads_list_crawler(html_doc)
    # Identify each iPhone with the h2 tag
    sleep(rand(0.0..3.0))
    html_doc.search('.annonce a').each do |element|
        ad_url = element.attribute('href').value
        puts ad_url
        img_div_array = []
        ad = ad_page_scrapper(ad_url, img_div_array)
    end

      # ad_title = element.attribute('title').value
      # if ad_title.downcase.start_with?('iphone') || ad_title.downcase.start_with?('vend iphone') ||ad_title.downcase.start_with?('vends iphone')

      #   # Save ad_page url
      #   ad_url = "https:#{element.attribute('href').value.split('?')[0]}"

      #   # Retrieve city from product_card
      #   meta_result = element.search('meta').first
      #   if meta_result['itemprop'] == 'address'
      #     ad_location = meta_result['content'].split('/')[0]
      #   end

      #   # Retrieve price from product_card
      #   ad_price = 0
      #   element.search('h3').each do |h3_result|
      #     if h3_result['itemprop'] == 'price'
      #       ad_price = h3_result['content'].to_i
      #     end
      #   end

      #   img_div_array = []
      #   ad = lbc_product_page_scrapper(ad_title, ad_url, ad_location, ad_price, img_div_array)

      #   compare_ad_to_database(ad, img_div_array)
      # end
  # end

  def ad_page_scrapper(ad_url, img_div_array)
    # Open ad_page
    ad_doc = Nokogiri::HTML(open(ad_url).read)

    # Retrieve title from ad_page
    ad_title = ad_doc.xpath('//meta[@itemprop="name"]').attribute('content').value
    puts ad_title
    return if !ad_title.downcase.start_with?('iphone') #|| !ad_title.downcase.start_with?('vend iphone') || !ad_title.downcase.start_with?('vends iphone')

    # Retrieve price from ad_page
    ad_price = ad_doc.xpath('//meta[@itemprop="price"]').attribute('content').value
    puts ad_price

    # Retrieve location from ad_page
    ad_location = ad_doc.xpath('//div[@class="infosann"]/p/strong').text.gsub(/[^0-9a-z, -]/i, '')
    puts ad_location

    # Retrieve date from ad_page
    ad_datetime = DateTime.now
    puts ad_datetime

    # Retrieve description (as html string) from ad_page
    ad_description = ad_doc.xpath('//div[@class="v2-txtdetail"]/div[@class="txt"]').inner_html.gsub(/<h2 style.*\z/, '').gsub(/.*<p itemprop="description">/, '').gsub('</p>', '')
    puts ad_description

    # Retrieve images url from ad_page
    ad_doc.xpath('//img[starts-with(@id, "miniphoto")]').each do |res|
        img_div_array << res.attribute('onclick').value.gsub(/.*.attr\('src','/, '').gsub(/\'\);\$\(\'.mini\'\).removeClass.*/, '')
    end

    # Find product and return new ad
    # product = Product.find_by(version: @version, capacity: 0, color: 'unknown', brand: @brand)
    # return Ad.new(title: ad_title, description: ad_description, url: ad_url, date: ad_datetime, location: ad_location, price: ad_price, source: "paruvendu", product: product)
  end

#   def compare_ad_to_database(ad, img_div_array)
#     puts "======================================="
#     puts ad.url
#     if Ad.find_by(url: ad.url).nil?
#       puts "+++ Creating new ad +++"
#       ad.save!
#       img_div_array.uniq!
#       img_div_array.each do |pic_url|
#         Picture.create!(url: pic_url, ad: ad)
#       end
#     else
#       puts "--- Ad already exists ---"
#     end
#   end
end

# ParuvenduScrappingService.new(name: 'iPhone', version: "3GS", location: 'Paris', brand: "Apple").page_iterator
