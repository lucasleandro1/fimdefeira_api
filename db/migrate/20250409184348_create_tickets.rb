class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.references :client, null: false, foreign_key: true
      t.references :supermarket, null: false, foreign_key: true
      t.decimal :total_price

      t.timestamps
    end
  end
end
