class RemoveCityAndZipcodeFromAds < ActiveRecord::Migration[5.1]
  def change
    remove_column :ads, :zipcode
    remove_column :ads, :city
  end
end
