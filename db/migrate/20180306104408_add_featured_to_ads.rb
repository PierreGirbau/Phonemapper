class AddFeaturedToAds < ActiveRecord::Migration[5.1]
  def change
    add_column :ads, :featured, :boolean
  end
end
