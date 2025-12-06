module Opensearch
  class CompaniesToCsvQuery

    def response
      search_body = {
        query: {
          bool: {
            must: [],
            filter: [
              # { terms: { "countries.keyword": ["US"] } },
              # { terms: { "programming_languages.keyword": ["Ruby"] } },
              # { terms: { "frameworks.keyword": [] } },
              # { terms: { "other_tech_stack.keyword": [] } }
            ]
          }
        },
        size: 0,
        aggs: {
          aggregate_by_country: {
            terms: {
              field: "countries.keyword",
              size: 5
            }
          },
          # top_countries_hits: {
          #   top_hits: {
          #     size: 100 # TO DO Need to add paging
          #     # sort: [
          #     #   {
          #     #     created_at: {
          #     #       order: "DESC"
          #     #     }
          #     #   }
          #     # ],
          #     # _source: {
          #     #   includes: [ "name", "url", "countries" ]
          #     # }
          #   }
          # }
        }
      }

      response = OPENSEARCH_CLIENT.search(
        index: "companies", #Company::INDEX_NAME,
        body: search_body
      )
    end

  end
end
