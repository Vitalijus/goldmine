class CreateApplicants < ActiveRecord::Migration[8.0]
  def change
    create_table :applicants, id: :uuid do |t|
      t.references :career, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :surname
      t.string :email
      t.string :phone
      t.string :country
      t.string :city
      t.string :linkedin_url
      t.string :github_url
      t.text :cover_letter
      t.string :expected_salary
      t.string :availability
      t.string :resume

      t.timestamps
    end
  end
end
