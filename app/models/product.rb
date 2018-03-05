class Product < ApplicationRecord
  belongs_to :brand
  has_many :ads
  paginates_per 9
end
