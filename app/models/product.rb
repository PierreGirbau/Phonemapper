class Product < ApplicationRecord
  belongs_to :brand
  has_many :ads

  include PgSearch
  multisearchable against: [ :title, :name ]
end
