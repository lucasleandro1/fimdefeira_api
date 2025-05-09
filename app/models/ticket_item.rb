class TicketItem < ApplicationRecord
  belongs_to :ticket
  belongs_to :post

  before_save :calculate_subtotal_price

  private

  def calculate_subtotal_price
    self.subtotal_price = product.price * quantity
  end
end
