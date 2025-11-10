require 'rails_helper'

RSpec.describe "applicants/edit", type: :view do
  let(:applicant) {
    Applicant.create!(
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
    )
  }

  before(:each) do
    assign(:applicant, applicant)
  end

  it "renders the edit applicant form" do
    render

    assert_select "form[action=?][method=?]", applicant_path(applicant), "post" do

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
