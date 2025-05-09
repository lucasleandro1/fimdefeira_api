class Ticket < ApplicationRecord
  belongs_to :client
  belongs_to :supermarket
  has_many :ticket_items, dependent: :destroy
  validates :ticket_items, presence: true

  def expired?
    created_at < 6.hours.ago
  end

  def destroy_if_expired
    destroy if expired?
  end

  before_save :calculate_total_price

  private

  def calculate_total_price
    self.total_price = ticket_items.sum(:subtotal_price)
  end
end
