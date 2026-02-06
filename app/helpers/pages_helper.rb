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

  # Total companies count for dynamic header text or email content. 
  # Rounded to nearest 10 for better readability.
  def total_companies
    companies_count = Company.all.count
    rounded_count = (companies_count / 10) * 10
    "#{rounded_count}+"
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

  # Dynamic header text
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
