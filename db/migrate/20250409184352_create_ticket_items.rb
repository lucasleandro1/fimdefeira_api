class CreateTicketItems < ActiveRecord::Migration[8.0]
  def change
    create_table :ticket_items do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :subtotal_price

      t.timestamps
    end
  end
end
