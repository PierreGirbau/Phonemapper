# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Cleaning database...'
Product.destroy_all

puts 'Creating brands...'
apple = Brand.new(name: 'Apple')
samsung = Brand.new(name: 'Samsung')

puts 'Creating products...'

require 'open-uri'
require 'nokogiri'

url_fr = "https://support.apple.com/fr-fr/HT201296"

html_file = open(url_fr).read
html_doc = Nokogiri::HTML(html_file)

def create_image_link_table(html_doc)
  img_link_hash = {}
  html_doc.search('img').each do |img|
    link = img.attr('src')
    if link != "/library/content/dam/edam/applecare/images/en_US/mac_apps/itunes/divider.png" && link != "https://www.apple.com/support/assets/ac-globalfooter/1/fr_FR/images/ac-globalfooter/globalfooter/footer/country/flag_large_2x.png"
      version = link.match(/(iphone|-)(original|se|x|[1-9]).*-colors.jpg/)[0].gsub('-colors.jpg', '').gsub('iphone', '').gsub('-', '').gsub('original', '2g').split('/')[0]
      img_link_hash[version] = "https://support.apple.com#{link}"
    end
  end
  return img_link_hash
end

# Retrieve all image links from html_doc
image_link_hash = create_image_link_table(html_doc)

# Identify each iPhone with the h2 tag
html_doc.search('h2').each do |element|
  if element.text.strip.start_with?('iPhone')
    # Isolate the product version from the product title
    version = element.text.strip.gsub('iPhone', '').gsub(/[^0-9a-z, ]/i, '').lstrip
    version = "2G" if version.empty?

    # Retrieve the div node containing the product description
    desc = element.parent.content

    # Create the capacity table from the product description
    capacity = desc.scan(/Capacité.*Go/).first.gsub('Capacité', '').gsub('Go', '').gsub(/[^0-9a-z, ]/i, '').split(',').map { |x| x.lstrip! }

    # Create the color table from the product description
    color_string = desc.scan(/Couleurs.*/).first
    if color_string.nil?
      version == "2G"? color = "aluminium" : color = "noir"
    else
      color = color_string.downcase.gsub('couleurs', '').gsub(':', '').gsub('et', ',').gsub('(product)red', 'rouge').gsub(/[^0-9a-zé, ]/i, '').split(',').map! { |x| x.lstrip }
    end

    puts "- iPhone #{version} products"
    capacity.each do |cap|
      if color.is_a?(Array)
        color.each do |col|
          Product.create!(brand: apple, name: "iPhone", version: version, capacity: cap.to_i, color: col, price: 1000, picture: image_link_hash[version.downcase])
        end
      else
        Product.create!(brand: apple, name: "iPhone", version: version, capacity: cap.to_i, color: color, price: 1000, picture: image_link_hash[version.downcase])
      end
    end

  end
end

puts 'Finished!'
