class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.date :expiration_date
      t.decimal :price
      t.integer :stock_quantity
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
