class ScrapProductJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)
    puts "Calling LeboncoinScrappingService for #{product.name} #{product.version} in Paris..."
    LeboncoinScrappingService.new(name: product.name, version: product.version, location: 'Paris', brand: Brand.find(product.brand_id)).results_page_iterator

    puts "Calling VivastreetScrappingService for #{product.name} #{product.version} in Paris..."
    VivastreetScrappingService.new(name: product.name, version: product.version, location: 'Paris', brand: Brand.find(product.brand_id)).results_page_iterator

    puts "Done!"
  end
end
