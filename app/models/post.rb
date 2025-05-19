class Post < ApplicationRecord
  belongs_to :supermarket
  belongs_to :product
  belongs_to :branch
end
