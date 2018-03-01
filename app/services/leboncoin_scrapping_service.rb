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
    sleep(rand(0.0..3.0))
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
      if ad_title.downcase.start_with?('iphone') || ad_title.downcase.start_with?('vend iphone') ||ad_title.downcase.start_with?('vends iphone')

        # Save product_page url
        ad_url = "https:#{element.attribute('href').value.split('?')[0]}"

        # Retrieve city from product_card
        meta_result = element.search('meta').first
        if meta_result['itemprop'] == 'address'
          ad_location = meta_result['content'].split('/')[0]
        end

        # Retrieve price from product_card
        ad_price = 0
        element.search('h3').each do |h3_result|
          if h3_result['itemprop'] == 'price'
            ad_price = h3_result['content'].to_i
          end
        end

        img_div_array = []
        ad = lbc_product_page_scrapper(ad_title, ad_url, ad_location, ad_price, img_div_array)

        compare_ad_to_database(ad, img_div_array)
      end
    end
  end

  def lbc_product_page_scrapper(ad_title, ad_url, ad_location, ad_price, img_div_array)
    # Open product_page
    product_file = open(ad_url).read
    product_doc = Nokogiri::HTML(product_file)

    # Retrieve date from product_page
    ad_datetime =  DateTime.strptime(product_doc.xpath('//div[@data-qa-id="adview_date"]').text, '%e/%m/%Y à %Hh%M')

    # Retrieve description (as html string) from product_page
    ad_description = product_doc.xpath('//div[@data-qa-id="adview_description_container"]').css('span').first.inner_html

    # Retrieve images url from product_page
    product_doc.xpath('//div[starts-with(@style, "background-image:url")]').each do |res|
      img_div_array << res.attribute('style').value.gsub('background-image:url(', '').gsub(');', '')
    end

    # Find product and return new ad
    product = Product.find_by(version: @version, capacity: 0, color: 'unknown', brand: @brand)
    return Ad.new(title: ad_title, description: ad_description, url: ad_url, date: ad_datetime, location: ad_location, price: ad_price, source: "leboncoin", product: product)
  end

  def compare_ad_to_database(ad, img_div_array)
    puts "======================================="
    puts ad.url
    if Ad.find_by(url: ad.url).nil?
      puts "+++ Creating new ad +++"
      ad.save!
      img_div_array.uniq!
      img_div_array.each do |pic_url|
        Picture.create!(url: pic_url, ad: ad)
      end
    else
      puts "--- Ad already exists ---"
    end
  end
end
