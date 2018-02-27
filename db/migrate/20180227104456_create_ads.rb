class CreateAds < ActiveRecord::Migration[5.1]
  def change
    create_table :ads do |t|
      t.string :title
      t.text :description
      t.string :url
      t.datetime :date
      t.integer :price
      t.string :simlock
      t.integer :zipcode
      t.integer :city
      t.references :picture, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
