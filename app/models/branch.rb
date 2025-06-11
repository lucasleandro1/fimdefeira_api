class Branch < ApplicationRecord
  belongs_to :supermarket
  has_many :posts, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :products, dependent: :destroy
end
