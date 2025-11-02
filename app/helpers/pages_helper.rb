module PagesHelper
  def companies_total_helper(countries)
    Company.all.select { |c| (c.countries & countries).any? }.count
  end
end
