class Ad < ApplicationRecord
  has_many :pictures
  belongs_to :product
end
