require 'rails_helper'

RSpec.describe "applicants/new", type: :view do
  before(:each) do
    assign(:applicant, Applicant.new(
      name: "MyString",
      surname: "MyString",
      email: "MyString",
      phone: "MyString",
      location: "MyString",
      linkedin_url: "MyString",
      github_url: "MyString",
      cover_letter: "MyText",
      expected_salary: "MyString",
      availability: "MyString",
      resume: "MyString"
    ))
  end

  it "renders new applicant form" do
    render

    assert_select "form[action=?][method=?]", applicants_path, "post" do

      assert_select "input[name=?]", "applicant[name]"

      assert_select "input[name=?]", "applicant[surname]"

      assert_select "input[name=?]", "applicant[email]"

      assert_select "input[name=?]", "applicant[phone]"

      assert_select "input[name=?]", "applicant[location]"

      assert_select "input[name=?]", "applicant[linkedin_url]"

      assert_select "input[name=?]", "applicant[github_url]"

      assert_select "textarea[name=?]", "applicant[cover_letter]"

      assert_select "input[name=?]", "applicant[expected_salary]"

      assert_select "input[name=?]", "applicant[availability]"

      assert_select "input[name=?]", "applicant[resume]"
    end
  end
end
