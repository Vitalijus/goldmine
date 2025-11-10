require 'rails_helper'

RSpec.describe "careers/new", type: :view do
  before(:each) do
    assign(:career, Career.new(
      title: "MyString",
      description: "MyText",
      location: "MyString",
      employment_type: "MyString",
      salary_range: "MyString",
      active: false
    ))
  end

  it "renders new career form" do
    render

    assert_select "form[action=?][method=?]", careers_path, "post" do

      assert_select "input[name=?]", "career[title]"

      assert_select "textarea[name=?]", "career[description]"

      assert_select "input[name=?]", "career[location]"

      assert_select "input[name=?]", "career[employment_type]"

      assert_select "input[name=?]", "career[salary_range]"

      assert_select "input[name=?]", "career[active]"
    end
  end
end
