class Company < ApplicationRecord
  after_commit :index_document, on: [:create, :update]
  after_commit :delete_document, on: [:destroy]

  # To index existing records run in rails c
  # Company.find_each do |company|
  #   company.send(:index_document)
  # end

  # To create index run in rails c
  # OPENSEARCH_CLIENT.indices.create(
  #   index: "companies"
  # )

  # To delete index run in rails c
  # OPENSEARCH_CLIENT.indices.delete(
  #   index: "companies"
  # )

  # List all indices
  # OPENSEARCH_CLIENT.cat.indices(format: 'json')

  # Get mapping for a specific index
  # OPENSEARCH_CLIENT.indices.get_mapping(index: 'companies')

  # Define the index name
  INDEX_NAME = 'companies'

  def as_indexed_json
    {
      name: name,
      url: url,
      countries: countries,                         # array of strings
      programming_languages: programming_languages, # array of strings
      frameworks: frameworks,                       # array of strings
      other_tech_stack: other_tech_stack,           # array of strings
      cities: cities,                               # array of strings
      remote: remote,
      origin: origin,
      created_at: created_at,
      updated_at: updated_at

    }
  end

  private

  def index_document
    OPENSEARCH_CLIENT.index(
      index: INDEX_NAME,
      id: id,
      body: as_indexed_json
    )
  end

  def delete_document
    OPENSEARCH_CLIENT.delete(
      index: INDEX_NAME,
      id: id
    )
  rescue OpenSearch::Transport::Transport::Errors::NotFound
    # Ignore if document not found
  end
end
