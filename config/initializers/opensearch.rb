# To start OpenSearch locally run: opensearch
# Keep in mind this will establish insecure connection

require 'opensearch-ruby'

if Rails.env.production?
  OPENSEARCH_CLIENT = OpenSearch::Client.new(url: ENV['BONSAI_URL'])
else
  OPENSEARCH_CLIENT = OpenSearch::Client.new(
    host: 'http://localhost:9200',
    user: 'admin',
    password: 'admin',
    transport_options: { ssl: { verify: false } }
  )
end
