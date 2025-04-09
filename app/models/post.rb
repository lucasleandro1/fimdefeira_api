class Post < ApplicationRecord
  belongs_to :supermarket
  belongs_to :product
end
