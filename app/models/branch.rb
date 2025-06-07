class Branch < ApplicationRecord
  belongs_to :supermarket
  has_many :posts
  has_many :products
end
