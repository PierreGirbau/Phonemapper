class Ad < ApplicationRecord
  has_many :pictures
  belongs_to :product

  include PgSearch
  multisearchable against: [ :title, :name ]
end
