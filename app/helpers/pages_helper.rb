require 'csv'

module PagesHelper
  def total_companies_by_country_helper(countries)
    select_companies(countries).count
  end

  def total_companies
    Company.all.count
  end

  # generate CSV sample file
  def companies_sample_file_helper(countries)
    companies = select_companies(countries).sort_by(&:updated_at).first(10)
    company_hashes = companies.map do |company|
      {
        name: company.name,
        url: company.url,
        updated_at: company.updated_at,
        programming_languages: company.programming_languages.join(", "),
        frameworks: company.frameworks.join(", "),
        countries: company.countries.join(", ")
      }
    end

    CSV.generate(write_headers: true, headers: company_hashes.first&.keys) do |csv|
      company_hashes.each { |company| csv << company.values }
    end
  end

  def select_companies(countries)
    Company.where("countries && ARRAY[?]::text[]", countries)
  end
end
