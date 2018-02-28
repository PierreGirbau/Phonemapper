class AddLocationToAds < ActiveRecord::Migration[5.1]
  def change
    add_column :ads, :location, :string
  end
end
