class AddAdReferenceToPictures < ActiveRecord::Migration[5.1]
  def change
    add_reference :pictures, :ad, foreign_key: true
  end
end
