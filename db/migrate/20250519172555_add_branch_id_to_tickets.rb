class AddBranchIdToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :branch_id, :integer
  end
end
