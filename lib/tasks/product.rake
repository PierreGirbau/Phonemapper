namespace :product do
  desc "Scrapping all product with LeboncoinScrappingService"
  task leboncoin_scrapping: :environment do
    products = Product.all
    products.each do |p|
      ScrapProductJob.perform(p.id)
    end
  end

end
