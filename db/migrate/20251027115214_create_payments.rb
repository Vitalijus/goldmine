class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments, id: :uuid do |t|
      t.string :stripe_payment_intent
      t.integer :amount
      t.string :stripe_product_id
      t.string :client_email

      t.timestamps
    end
  end
end
