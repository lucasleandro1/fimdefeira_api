class TicketItem < ApplicationRecord
  belongs_to :ticket
  belongs_to :product
end
