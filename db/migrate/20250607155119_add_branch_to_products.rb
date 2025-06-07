class AddBranchToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :branch, null: true, foreign_key: true
  end
end
