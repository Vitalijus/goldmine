require 'rails_helper'

RSpec.describe "careers/index", type: :view do
  before(:each) do
    assign(:careers, [
      Career.create!(
        title: "Title",
        description: "MyText",
        location: "Location",
        employment_type: "Employment Type",
        salary_range: "Salary Range",
        active: false
      ),
      Career.create!(
        title: "Title",
        description: "MyText",
        location: "Location",
        employment_type: "Employment Type",
        salary_range: "Salary Range",
        active: false
      )
    ])
  end

  it "renders a list of careers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Location".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Employment Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Salary Range".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
