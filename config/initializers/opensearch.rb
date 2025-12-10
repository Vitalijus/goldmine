require 'opensearch-ruby'

if Rails.env.production?
  OPENSEARCH_CLIENT = OpenSearch::Client.new(url: ENV['BONSAI_URL'])
else
  OPENSEARCH_CLIENT = OpenSearch::Client.new(
    host: 'https://localhost:9200',
    user: 'admin',
    password: 'admin',
    transport_options: { ssl: { verify: false } }
  )
end
