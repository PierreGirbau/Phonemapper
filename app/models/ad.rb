class Ad < ApplicationRecord
  belongs_to :picture
  belongs_to :product

  include PgSearch
  multisearchable against: [ :title, :name ]
end
