class Post < ApplicationRecord
  belongs_to :product
  belongs_to :branch
  belongs_to :supermarket
end
