class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: { to_table: :users }
      t.decimal :total_price

      t.timestamps
    end
  end
end
