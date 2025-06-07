class Product < ApplicationRecord
  belongs_to :supermarket
  belongs_to :branch
  has_one_attached :photo
end
