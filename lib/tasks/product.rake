namespace :product do
  desc "Scrapping all product with LeboncoinScrappingService"
  task leboncoin_scrapping: :environment do
    products = Product.where(capacity: 0)
    products.each do |p|
      ScrapProductJob.perform_now(p.id)
    end
  end

end
