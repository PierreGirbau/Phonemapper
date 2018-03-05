class Ad < ApplicationRecord
  has_many :pictures
  belongs_to :product

  geocoded_by :location
  after_validation :geocode

  # include PgSearch
  # multisearchable against: [ :title, :name ]
end
