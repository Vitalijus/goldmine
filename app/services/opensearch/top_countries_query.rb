require_relative "../utils/pricing"

module Opensearch
  class TopCountriesQuery < Base
    include Pricing

    def initialize(countries: ["US", "GB", "CA", "DE", "AU"])
      @countries = countries
    end

    def build_result
      response = response(Company::INDEX_NAME, query)

      total_countries = response.dig("aggregations", "aggregate_by_country", "buckets").map do |bucket|
        next unless @countries.include?(bucket["key"])
        price = Pricing.price_rates.select { |item| item[:total_companies].include?(bucket["doc_count"]) }

        {
          country: ISO3166::Country.new(bucket["key"]).common_name,
          total_companies: bucket["doc_count"],
          price: price.first[:price],
          stripe_payment_link: price.first[:stripe_payment_link],
          popular_languages: popular_languages(bucket)&.join(", ")
        }
      end

      total_countries.compact
    end

    def popular_languages(bucket)
      bucket.dig("popular_languages_aggs", "buckets").map{ |bucket| bucket["key"] }
    end

    def query
      {
        query: {
          match_all: {}
        },
        size: 0,
        aggs: {
          aggregate_by_country: {
            terms: {
              field: "countries.keyword",
              size: 300
            },
            aggs: {
              popular_languages_aggs: {
                terms: {
                  field: "programming_languages.keyword",
                  size: 3
                }
              }
            }
          }
        }
      }
    end
  end
end
