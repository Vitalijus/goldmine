require 'rails_helper'

RSpec.describe "careers/edit", type: :view do
  let(:career) {
    Career.create!(
      title: "MyString",
      description: "MyText",
      location: "MyString",
      employment_type: "MyString",
      salary_range: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:career, career)
  end

  it "renders the edit career form" do
    render

    assert_select "form[action=?][method=?]", career_path(career), "post" do

      assert_select "input[name=?]", "career[title]"

      assert_select "textarea[name=?]", "career[description]"

      assert_select "input[name=?]", "career[location]"

      assert_select "input[name=?]", "career[employment_type]"

      assert_select "input[name=?]", "career[salary_range]"

      assert_select "input[name=?]", "career[active]"
    end
  end
end
