class CreateSamples < ActiveRecord::Migration[8.0]
  def change
    create_table :samples, id: :uuid do |t|
      t.string :email
      t.text :programming_languages, array: true, default: [], null: false
      t.text :frameworks, array: true, default: [], null: false
      t.text :other_tech_stack, array: true, default: [], null: false
      t.text :countries, array: true, default: [], null: false

      t.timestamps
    end
  end
end
