namespace :product do
  desc "Scrapping all product with LeboncoinScrappingService"
  task leboncoin_scrapping: :environment do
    products = Product.all
    products.each do |p|
      ScrapProductJob.perform_now(p.id)
    end
  end

end
