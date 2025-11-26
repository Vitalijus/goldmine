require 'opensearch-ruby'

OPENSEARCH_CLIENT = OpenSearch::Client.new(
  host: ENV['OPENSEARCH_URL'] || 'https://localhost:9200',
  user: ENV['OPENSEARCH_USER'] || 'admin',
  password: ENV['OPENSEARCH_PASSWORD'] || 'admin',
  log: true,
  transport_options: {
    ssl: { verify: false }# For testing only. Use certificate for validation.
  }
)
