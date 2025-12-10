class AddCountriesAndProgrammingLanguagesAndFrameworksAndOtherTechStackAndRemoteToPayments < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :countries, :text, array: true, default: [], null: false
    add_column :payments, :programming_languages, :text, array: true, default: [], null: false
    add_column :payments, :frameworks, :text, array: true, default: [], null: false
    add_column :payments, :other_tech_stack, :text, array: true, default: [], null: false
    add_column :payments, :cities, :text, array: true, default: [], null: false
    add_column :payments, :remote, :boolean
  end
end
