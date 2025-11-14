require 'csv'

# --- Run the parser ---
# CsvParser::CompaniesList.new("csv/weworkremotely.csv").run

module CsvParser
  class CompaniesList
    def initialize(companies_input="csv/rubyonremote.csv")
      @input_path = companies_input
    end

    def run
      p "Start parsing companies input CSV"
      companies = companies_input

      p "Create or update a company"
      create_or_update_company(companies)
    end

    def companies_input
      begin
        companies = CSV.read(@input_path, headers: true).map(&:to_h)
        companies.each{ |company| build_data(company) }
      rescue Errno::ENOENT => e
        Rails.logger.error("File is missing: #{e.message}")
        []
      rescue StandardError => e
        Rails.logger.error("File is corrupt: #{e.message}")
        []
      end
    end

    def build_data(company)
      {
        company_name: company["company_name"],
        company_url: company["company_url"],
        programming_languages: parse_json_array(company, "programming_languages"),
        frameworks: parse_json_array(company, "frameworks"),
        other_tech_stack: parse_json_array(company, "other_tech_stack"),
        remote: parse_json_array(company, "remote"),
        origin: company["origin"],
        countries: parse_json_array(company, "countries"),
        cities: parse_json_array(company, "cities")
      }
    end

    def create_or_update_company(companies)
      return if companies.empty?

      begin
        companies.each do |company|
          find_company = Company.find_by(url: company["company_url"])

          if find_company.present?
           find_company.update(update_company(find_company, company))
          else
           Company.create!(create_company(company))
          end
        end
      rescue StandardError => e
        Rails.logger.error("Could not create or update Company: #{e.message}")
        nil
      end
    end

    def update_company(find_company, company)
      {
        programming_languages: (find_company.programming_languages + parse_json_array(company, "programming_languages")).uniq,
        frameworks: (find_company.frameworks + parse_json_array(company, "frameworks")).uniq,
        other_tech_stack: (find_company.other_tech_stack + parse_json_array(company, "other_tech_stack")).uniq,
        countries: (find_company.countries + parse_json_array(company, "countries")).uniq,
        cities: (find_company.cities + parse_json_array(company, "cities")).uniq
      }
    end

    def create_company(company)
      {
        name: company["company_name"],
        url: company["company_url"],
        programming_languages: parse_json_array(company, "programming_languages"),
        frameworks: parse_json_array(company, "frameworks"),
        other_tech_stack: parse_json_array(company, "other_tech_stack"),
        remote: parse_json_array(company, "remote"),
        origin: company["origin"],
        countries: parse_json_array(company, "countries"),
        cities: parse_json_array(company, "cities")
      }
    end

    def parse_json_array(company, attr)
      JSON.parse(company[attr])
    end
  end
end
