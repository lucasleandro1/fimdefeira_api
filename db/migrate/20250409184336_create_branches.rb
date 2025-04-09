class CreateBranches < ActiveRecord::Migration[8.0]
  def change
    create_table :branches do |t|
      t.references :supermarket, null: false, foreign_key: true
      t.string :address
      t.string :telephone

      t.timestamps
    end
  end
end
