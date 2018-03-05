class Ad < ApplicationRecord
  has_many :pictures
  belongs_to :product

  include PgSearch
  pg_search_scope :search_by_title, :against => :title
end
