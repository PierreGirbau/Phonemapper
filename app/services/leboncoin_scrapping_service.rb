require 'open-uri'
require 'nokogiri'

class LeboncoinScrappingService
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
      url = "https://www.leboncoin.fr/annonces/offres/?o=#{i}&q=#{@name.downcase}%20#{@version}&location=#{@location}"
      html_doc = Nokogiri::HTML(open(url).read)
      break if !html_doc.xpath('//article[contains(@class, "noResult")]').text.empty? || i > 2
      puts "============================ PAGE #{i} ============================="
      ads_list_crawler(html_doc)
      i += 1
    end
  end

  def ads_list_crawler(html_doc)
    html_doc.search('.tabsContent a').each do |element|
      puts "======================================="
      ad_url = "https:#{element.attribute('href').value.split('?')[0]}"
      img_div_array = []
      ad_page_scrapper(ad_url, img_div_array)
    end
  end

  def ad_page_scrapper(ad_url, img_div_array)
    # Open ad_page
    ad_doc = Nokogiri::HTML(open(ad_url).read)

    # Retrieve title from ad_page
    ad_title = ad_doc.xpath('//div[@data-qa-id="adview_title"]/h1').text
    return if !ad_title.downcase.start_with?('iphone') #|| !ad_title.downcase.start_with?('vend iphone') || !ad_title.downcase.start_with?('vends iphone')

    # Retrieve ad_price from ad_page
    ad_price = ad_doc.xpath('//div[@data-qa-id="adview_price"]').text.split('€').first.to_i

    # Retrieve location from ad_page
    ad_location = ad_doc.xpath('//div[@data-qa-id="adview_location_informations"]').text.gsub('Voir sur la carte', '')

    # Retrieve date from ad_page
    ad_datetime = DateTime.strptime(ad_doc.xpath('//div[@data-qa-id="adview_date"]').text, '%e/%m/%Y à %Hh%M')

    # Retrieve description (as html string) from ad_page
    ad_description = ad_doc.xpath('//div[@data-qa-id="adview_description_container"]').css('span').first.inner_html

    # Retrieve images url from ad_page
    ad_doc.xpath('//div[starts-with(@style, "background-image:url")]').each do |res|
      img_div_array << res.attribute('style').value.gsub('background-image:url(', '').gsub(');', '')
    end

    # Find corresponding product and return new ad
    product = Product.find_by(version: @version, capacity: 0, color: 'unknown', brand: @brand)
    ad = Ad.new(title: ad_title, description: ad_description, url: ad_url, date: ad_datetime, location: ad_location, price: ad_price, source: "leboncoin", product: product)
    compare_ad_to_database(ad, img_div_array)
  end

  def compare_ad_to_database(ad, img_div_array)
    puts ad.url
    if Ad.find_by(url: ad.url).nil?
      puts "+++ Creating new ad +++"
      ad.save
      img_div_array.uniq!
      if !img_div_array.nil?
        img_div_array.each do |pic_url|
        Picture.create!(url: pic_url, ad: ad)
       end
      end
    else
      puts "--- Ad already exists ---"
    end
  end
end
