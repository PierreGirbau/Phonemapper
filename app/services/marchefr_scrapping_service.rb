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
    i = 1
    # Iterate over each page result while not empty
    loop do
      url = "https://www.paruvendu.fr/mondebarras/listefo/default/default/?fulltext=iPhone&libelle_lo=Paris&codeinsee=&lo=75&ray=0&p=#{i}"
      puts url
      begin
        html_doc = Nokogiri::HTML(open(url).read)
        break if i > 20 #!html_doc.xpath('//article[contains(@class, "noResult")]').text.empty? || i > 4
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
      # puts link.attribute('href').value
      # puts "========================="
      if (/https:\/\/www.paruvendu.fr\/annonces\/high-tech\/(iphone|apple).*/).match?(link.attribute('href').value)
        puts "======================================="
        ad_url = link.attribute('href').value
        puts ad_url

        if Ad.find_by(url: ad_url).nil?
          puts "+++ Creating new ad +++"
          begin
           ad_page_scrapper(ad_url)
          rescue => e
            puts e
          end
        else
          puts "--- Ad already exists ---"
        end

      else
          puts "#{ad_url} => NOT AN IPHONE"
      end
    end
  end

  def ad_page_scrapper(ad_url)
    sleep(rand(0.0..5.0))
    # Open ad_page
    ad_doc = Nokogiri::HTML(open(ad_url).read)

    # # Retrieve title from ad_page
    ad_title = ad_doc.search("h1").first.text.lstrip.rstrip #.inner_html.lstrip.split('<span').first.rstrip
    puts ad_title

    # # Retrieve ad_price from ad_page
    ad_price = ad_doc.search(".prix").text.scan(/\d+/).first.to_i
    puts ad_price

    # # Retrieve location from ad_page
    ad_location = "Paris #{ad_url.scan(/paris.*\d+\//).first.scan(/75\d+/).first}"
    puts ad_location

    # # Retrieve date from ad_page
    # ad_datetime = ad_doc.xpath("//span[@class = 'pro_users_only']").first.text.gsub(' le ', '')
    ad_datetime = DateTime.now #strptime(ad_doc.xpath("//span[@class = 'pro_users_only']").first.text.gsub(' le ', ''), '%d/%m/%Y')
    puts ad_datetime

    # Retrieve description (as html string) from ad_page
    ad_description = ad_doc.search(".txt")#xpath('//p[@itemprop = "description"]')
    if ad_description.nil?
      ad_description = ""
    else
      ad_description = ad_description.inner_html.gsub(' itemprop="description"', '').gsub('<p>', '').gsub('</p>', "").split('<h2').first.lstrip
    end
    puts ad_description

    # Retrieve images url from ad_page
    img_div_array = ad_doc.inner_html.scan(/'https:\/\/media.paruvendu.fr\/image\/.*.jpeg'/).map { |x| x.gsub("'",'')}
    puts img_div_array

    # Find corresponding product and return new ad
    product = Product.find_by(version: @version, capacity: 0, color: 'unknown', brand: @brand)
    ad = Ad.new(title: ad_title, description: ad_description, url: ad_url, date: ad_datetime, location: ad_location, price: ad_price, source: "paruvendu", product: product)

    # ad.save
    if !img_div_array.nil?
      img_div_array.each { |pic_url| Picture.create!(url: pic_url, ad: ad) }
    end
  end
end

#ParuvenduScrappingService.new(name: 'iPhone', version: "8", location: 'Paris', brand: "Apple").results_page_iterator
#ParuvenduScrappingService.new(name: 'iPhone', version: "8", location: 'Paris', brand: "Apple").ad_page_scrapper("https://www.paruvendu.fr/annonces/high-tech/iphone-7-plus-128g-paris-75017/1224801551A1KBMUTT000")
#ParuvenduScrappingService.new(name: 'iPhone', version: "8", location: 'Paris', brand: Brand.find_by(name: "Apple")).results_page_iterator
