class Ad < ApplicationRecord
  has_many :pictures
  belongs_to :product
  paginates_per 6

  geocoded_by :location
  after_validation :geocode

  include PgSearch
  pg_search_scope :search_by_title, :against => :title
end
