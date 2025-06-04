class AddCuponsToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :cupons, :integer
  end
end
