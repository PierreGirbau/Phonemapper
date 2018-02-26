require 'open-uri'
require 'nokogiri'

url = "https://support.apple.com/en-us/HT201296"

html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

html_doc.search('h2').each do |element|
  if element.text.strip.start_with?('iPhone')
    puts element.text.strip
    desc = element.parent.content
    # puts desc
    capacity = desc.scan(/Capacity:.* GB/)
    puts capacity
    color = desc.scan(/Colors:.*/).first.gsub('Colors:', '').gsub(' and ', ',').gsub('(PRODUCT)RED', 'red').downcase.split(',').compact
    # color.map { |x| x.lstrip!.rstrip! }
    puts color
    puts "-----------------------"
  end
end
