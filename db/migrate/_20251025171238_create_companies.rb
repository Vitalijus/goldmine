class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies, id: :uuid do |t|
      t.string :name
      t.string :url
      t.string :country

      t.timestamps
    end
  end
end
