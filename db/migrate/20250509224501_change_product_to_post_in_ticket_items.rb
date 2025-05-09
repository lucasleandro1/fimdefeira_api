class ChangeProductToPostInTicketItems < ActiveRecord::Migration[8.0]
  def change
    remove_reference :ticket_items, :product, foreign_key: true

    add_reference :ticket_items, :post, null: false, foreign_key: true
  end
end
