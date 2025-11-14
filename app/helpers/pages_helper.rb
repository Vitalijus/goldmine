require 'csv'

module PagesHelper
  def total_by_country_language_framework_helper(countries, languages, frameworks)
    companies = select_companies(countries)

    companies.where(
      "programming_languages && ARRAY[?]::text[] OR frameworks && ARRAY[?]::text[]",
      languages,
      frameworks
    ).count
  end

  def total_companies
    companies_count = Company.all.count
    rounded_count = (companies_count / 10) * 10
    "#{rounded_count}+"
  end

  # generate CSV sample file
  def companies_sample_file_helper(countries)
    companies = select_companies(countries).sort_by(&:updated_at).first(10)
    company_hashes = companies.map do |company|
      {
        name: company.name,
        url: company.url,
        updated_at: company.updated_at&.strftime("%F"),
        programming_languages: company.programming_languages.join(", "),
        frameworks: company.frameworks.join(", "),
        countries: countries.join(", ")
      }
    end

    CSV.generate(write_headers: true, headers: company_hashes.first&.keys) do |csv|
      company_hashes.each { |company| csv << company.values }
    end
  end

  # download CSV companies list file
  def companies_export_file_helper(country, languages, frameworks)
    search_companies = select_companies(country)
    companies = search_companies.where(
      "programming_languages && ARRAY[?]::text[] OR frameworks && ARRAY[?]::text[]",
      languages,
      frameworks
    ).sort_by(&:updated_at)

    company_hashes = companies.map do |company|
      {
        name: company.name,
        url: company.url,
        updated_at: company.updated_at&.strftime("%F"),
        programming_languages: company.programming_languages.join(", "),
        frameworks: company.frameworks.join(", "),
        countries: country
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
