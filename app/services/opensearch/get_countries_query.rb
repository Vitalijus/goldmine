require_relative "../utils/pricing"

module Opensearch
  class GetCountriesQuery < Base
    include Pricing

    def initialize(countries:, languages:, frameworks:, other_tech:, remote:, size: 300)
      @countries = countries || ISO3166::Country.codes
      @languages = languages
      @frameworks = frameworks
      @other_tech = other_tech
      @remote = remote
      @size = size
    end

    def build_result
      response = response(Company::INDEX_NAME, query)

      total_countries = response.dig("aggregations", "aggregate_by_country", "buckets").map do |bucket|
        next unless @countries.include?(bucket["key"])
        price = Pricing.price_rates.select { |item| item[:total_companies].include?(bucket["doc_count"]) }

        search_attributes(bucket, price)
      end

      total_countries.compact
    end

    def search_attributes(bucket, price)
      {
        country: ISO3166::Country.new(bucket["key"]).common_name,
        total_companies: bucket["doc_count"],
        price: price.first[:price],
        stripe_payment_link: price.first[:stripe_payment_link]
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
        size: 0,
        aggs: {
          aggregate_by_country: {
            terms: {
              field: "countries.keyword",
              size: @size
            }
          }
        }
      }
    end

    def must_query
      filter = []
      filter << { term: { remote: @remote } } if @remote.present?
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
