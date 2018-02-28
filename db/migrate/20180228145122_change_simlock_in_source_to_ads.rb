class ChangeSimlockInSourceToAds < ActiveRecord::Migration[5.1]
  def change
    rename_column :ads, :simlock, :source
  end
end
