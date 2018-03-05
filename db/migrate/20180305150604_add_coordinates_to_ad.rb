class AddCoordinatesToAd < ActiveRecord::Migration[5.1]
  def change
    add_column :ads, :latitude, :float
    add_column :ads, :longitude, :float
  end
end
