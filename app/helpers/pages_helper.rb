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
    companies = Company.where("countries && ARRAY[?]::text[]", countries)
       .where("programming_languages IS NOT NULL AND array_length(programming_languages, 1) > 0").sort_by(&:updated_at).first(10)

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
  def companies_export_file_helper(payment)
    companies = Opensearch::CompaniesToCsvQuery.new(countries: payment.countries,
                                        languages: payment.programming_languages,
                                        frameworks: payment.frameworks,
                                        other_tech: payment.other_tech_stack,
                                        remote: payment.remote)
    csv_data = companies.build_result

    CSV.generate(write_headers: true, headers: csv_data.first&.keys) do |csv|
      csv_data.each { |company| csv << company.values }
    end
  end

  def select_companies(countries)
    Company.where("countries && ARRAY[?]::text[]", countries)
  end

  # Flags are used for dropdown select field
  def flag_for_country_name_helper(name)
    country = ISO3166::Country.find_country_by_any_name(name)
    return "" unless country&.alpha2

    country.alpha2.chars
           .map { |c| (c.ord + 127397).chr(Encoding::UTF_8) }
           .join
  end

  # Here is a dynamic header text
  def dynamic_header(countries, languages, total_companies)
    if countries&.first == "US" && languages&.first == "Ruby" && total_companies
      safe_join(["#{total_companies} companies in the ",
        content_tag(:span, "United States", class: "text-highligther")," actively hiring ",
        content_tag(:span, "#{languages&.present? ? languages.join(", ") :  "your stack"}", class: "text-highligther")," today."])
    else
      safe_join(["Companies actively hiring ", content_tag(:span, "your stack", class: "text-highligther")," today."])
    end
  end
end
