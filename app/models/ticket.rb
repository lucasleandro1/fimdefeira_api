class Ticket < ApplicationRecord
  belongs_to :client
  belongs_to :branch
  has_many :ticket_items, dependent: :destroy

  delegate :supermarket, to: :branch

  accepts_nested_attributes_for :ticket_items, allow_destroy: true
  validates_associated :ticket_items

  def expired?
    created_at < 3.hours.ago
  end

  def destroy_if_expired
    destroy if expired?
  end

  def calculate_total_price
    self.total_price = ticket_items.sum(&:subtotal_price)
  end
end
