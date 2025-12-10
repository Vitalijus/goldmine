module Opensearch
  class Base
    def response(index, query)
      OPENSEARCH_CLIENT.search(
        index: Company::INDEX_NAME,
        body: query
      )
    end
  end
end
