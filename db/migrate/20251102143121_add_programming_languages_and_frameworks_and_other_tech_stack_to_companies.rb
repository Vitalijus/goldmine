class AddProgrammingLanguagesAndFrameworksAndOtherTechStackToCompanies < ActiveRecord::Migration[8.0]
  def change
    remove_column :companies, :country
    add_column :companies, :programming_languages, :string, array: true, default: []
    add_column :companies, :frameworks, :string, array: true, default: []
    add_column :companies, :other_tech_stack, :string, array: true, default: []
    add_column :companies, :countries, :string, array: true, default: []
  end
end
