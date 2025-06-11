class Product < ApplicationRecord
  belongs_to :supermarket
  belongs_to :branch
  has_one_attached :photo

  has_many :posts
  validates :branch_id, presence: true

  def photo_url
    photo.attached? ? Rails.application.routes.url_helpers.url_for(photo) : nil
  end

  validate :expiration_date_cannot_be_in_the_past

  private

  def expiration_date_cannot_be_in_the_past
    if expiration_date.present? && expiration_date < Date.current
      errors.add(:expiration_date, "não pode ser anterior à data atual")
    end
  end
end
