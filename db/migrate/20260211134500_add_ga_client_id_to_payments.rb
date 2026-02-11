class AddGaClientIdToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :ga_client_id, :string
  end
end
