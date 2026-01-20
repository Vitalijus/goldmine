module Opensearch
  class CompaniesToCsvQuery < Base

    def initialize(countries:, languages:, frameworks:, other_tech:, remote:, size: 1000)
      @countries = countries
      @languages = languages
      @frameworks = frameworks
      @other_tech = other_tech
      @remote = remote
      @size = size
    end

    def build_result
      response = response(Company::INDEX_NAME, query)

      response.dig("hits", "hits").map do |company|
        source = company["_source"]
        company_attrs(source)
      end
    end

    def company_attrs(source)
      {
        name: source["name"],
        url: source["url"],
        updated_at: source["updated_at"]&.to_time&.strftime("%F"),
        programming_languages: source["programming_languages"]&.join(", "),
        frameworks: source["frameworks"]&.join(", "),
        countries: @countries&.join(", ")
      }
    end

    def query
      {
        query: {
          bool: {
            must: must_query,
            filter: query_filter
          }
        },
        sort: [
          { updated_at: { order: "desc" } }
        ],
        size: @size
      }
    end

    def must_query
      filter = []
        filter << { term: { remote: @remote } } unless @remote.nil?
      filter
    end

    def query_filter
      filter = []
      filter << { terms: { "countries.keyword": @countries } }             if @countries.present?
      filter << { terms: { "programming_languages.keyword": @languages } } if @languages.present?
      filter << { terms: { "frameworks.keyword": @frameworks } }           if @frameworks.present?
      filter << { terms: { "other_tech_stack.keyword": @other_tech } }     if @other_tech.present?
      filter
    end
  end
end
