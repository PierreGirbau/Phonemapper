require 'open-uri'
require 'nokogiri'

name = 'iPhone'
version = '3G'
city = 'Paris'

# File.open("lbccontent", 'wb') do |file|
#   file.write(open(url).read)
# end

# Scrap one page result
def leboncoin_scrap(html_doc)
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
        ad_city = meta_result['content'].split('/')[0]
        puts ad_city
      end

      # Retrieve price from product_card
      element.search('h3').each do |h3_result|
        if h3_result['itemprop'] == 'price'
          ad_price = h3_result['content'].to_i
          puts "#{ad_price} euros"
        end
      end

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

    puts "--------------------------------"
    # Ad.create!(title: title, )
    end
  end
end

# Iterate over each page result while not empty
i = 1
loop do
  url = "https://www.leboncoin.fr/annonces/offres/?o=#{i}&q=#{name.downcase}%20#{version}&location=#{city}"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  break if !html_doc.xpath('//article[contains(@class, "noResult")]').text.empty? || i > 20
  puts "============================ PAGE #{i} ============================="
  leboncoin_scrap(html_doc)
  i += 1
end



