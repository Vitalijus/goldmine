class AddAboutUsAndAboutRoleAndReqsAndOurCultureAndHowToApplyToCareers < ActiveRecord::Migration[8.0]
  def change
    remove_column :careers, :description
    add_column :careers, :about_us, :text
    add_column :careers, :about_role, :text
    add_column :careers, :reqs, :text
    add_column :careers, :our_culture, :text
    add_column :careers, :how_to_apply, :text
  end
end
