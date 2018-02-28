class RemovePictureReferenceFromAds < ActiveRecord::Migration[5.1]
  def change
    remove_reference :ads, :picture, index: true, foreign_key: true
  end
end
