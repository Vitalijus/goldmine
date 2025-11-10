require 'rails_helper'

RSpec.describe "careers/show", type: :view do
  before(:each) do
    assign(:career, Career.create!(
      title: "Title",
      description: "MyText",
      location: "Location",
      employment_type: "Employment Type",
      salary_range: "Salary Range",
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Employment Type/)
    expect(rendered).to match(/Salary Range/)
    expect(rendered).to match(/false/)
  end
end
