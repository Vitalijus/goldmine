require 'rails_helper'

RSpec.describe "applicants/index", type: :view do
  before(:each) do
    assign(:applicants, [
      Applicant.create!(
        name: "Name",
        surname: "Surname",
        email: "Email",
        phone: "Phone",
        location: "Location",
        linkedin_url: "Linkedin Url",
        github_url: "Github Url",
        cover_letter: "MyText",
        expected_salary: "Expected Salary",
        availability: "Availability",
        resume: "Resume"
      ),
      Applicant.create!(
        name: "Name",
        surname: "Surname",
        email: "Email",
        phone: "Phone",
        location: "Location",
        linkedin_url: "Linkedin Url",
        github_url: "Github Url",
        cover_letter: "MyText",
        expected_salary: "Expected Salary",
        availability: "Availability",
        resume: "Resume"
      )
    ])
  end

  it "renders a list of applicants" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Surname".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Phone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Linkedin Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Github Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Expected Salary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Availability".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Resume".to_s), count: 2
  end
end
