class AddRemoteAndCitiesAndOriginToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :cities, :text, array: true, default: [], null: false
    add_column :companies, :remote, :boolean
    add_column :companies, :origin, :string
  end
end
