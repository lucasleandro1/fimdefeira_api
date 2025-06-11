class Ticket < ApplicationRecord
  belongs_to :client
  belongs_to :branch, optional: true
  has_many :ticket_items, dependent: :destroy

  delegate :supermarket, to: :branch

  accepts_nested_attributes_for :ticket_items, allow_destroy: true
  validates_associated :ticket_items

  enum :status, pendente: 0, entregue: 1, expirado: 2

  def expired?
    created_at < 3.hours.ago
  end

  def destroy_if_expired
    if expired?
      ticket_items.each do |item|
      post = item.post
      product = post.product
      product.update!(stock_quantity: product.stock_quantity + item.quantity)
      end
      update!(status: :expirado)
      destroy
    end
  end

  def calculate_total_price
    self.total_price = ticket_items.sum(&:subtotal_price)
  end
end
