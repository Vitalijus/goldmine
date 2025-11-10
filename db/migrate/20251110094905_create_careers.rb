class CreateCareers < ActiveRecord::Migration[8.0]
  def change
    create_table :careers, id: :uuid do |t|
      t.string :title
      t.text :description
      t.string :location
      t.string :employment_type
      t.string :salary_range
      t.boolean :active
      t.text :keywords, default: [], null: false, array: true

      t.timestamps
    end
  end
end
