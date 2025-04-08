class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :store, class_name: "User"
  has_many :ticket_items
end
