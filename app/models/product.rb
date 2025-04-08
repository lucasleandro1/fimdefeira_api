class Product < ApplicationRecord
  belongs_to :user
  has_many :ticket_items
  has_many :posts
end
