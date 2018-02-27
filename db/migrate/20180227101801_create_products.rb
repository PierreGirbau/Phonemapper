class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :version
      t.integer :capacity
      t.string :color
      t.integer :price
      t.string :picture
      t.references :brand, foreign_key: true

      t.timestamps
    end
  end
end
