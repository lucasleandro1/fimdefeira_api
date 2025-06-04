class AddStatusToTickets < ActiveRecord::Migration[8.0]
  def change
    add_column :tickets, :status, :integer
  end
end
