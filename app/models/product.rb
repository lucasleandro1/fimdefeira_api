class Product < ApplicationRecord
  belongs_to :supermarket
  belongs_to :branch
  has_one_attached :photo

  has_many :posts
  validates :branch_id, presence: true

  def photo_url
    photo.attached? ? Rails.application.routes.url_helpers.url_for(photo) : nil
  end
end
