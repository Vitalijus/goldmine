require 'rails_helper'

RSpec.describe "applicants/show", type: :view do
  before(:each) do
    assign(:applicant, Applicant.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Surname/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Linkedin Url/)
    expect(rendered).to match(/Github Url/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Expected Salary/)
    expect(rendered).to match(/Availability/)
    expect(rendered).to match(/Resume/)
  end
end
