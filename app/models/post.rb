class Post < ApplicationRecord
  belongs_to :supermarket
  has_many :products
  belongs_to :branch
end
