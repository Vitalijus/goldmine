require_relative "../utils/pricing"

module Opensearch
  class TopCountriesQuery
    include Pricing

    def response
      OPENSEARCH_CLIENT.search(
        index: Company::INDEX_NAME,
        body: query
      )
    end

    def build_result
      response.dig("aggregations", "aggregate_by_country", "buckets").map do |bucket|
        price = Pricing.price_rates.select { |item| item[:total_companies].include?(bucket["doc_count"]) }

        {
          country: ISO3166::Country.new(bucket["key"]).common_name,
          total_companies: bucket["doc_count"],
          price: price.first[:price],
          stripe_payment_link: price.first[:stripe_payment_link]
        }
      end

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
              size: 5
            }
          }
        }
      }
    end

  end
end
