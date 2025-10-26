class AddCountryToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :country, :string
  end
end
