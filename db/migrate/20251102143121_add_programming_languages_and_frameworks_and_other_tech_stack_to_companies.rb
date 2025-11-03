class AddProgrammingLanguagesAndFrameworksAndOtherTechStackToCompanies < ActiveRecord::Migration[8.0]
  def change
    remove_column :companies, :country
    add_column :companies, :programming_languages, :text, array: true, default: []
    add_column :companies, :frameworks, :string, text: true, default: []
    add_column :companies, :other_tech_stack, :text, array: true, default: []
    add_column :companies, :countries, :text, array: true, default: []
  end
end
