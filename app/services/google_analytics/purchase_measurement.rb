require 'net/http'
require 'uri'
require 'json'

class GoogleAnalytics::PurchaseMeasurement
    def self.send_ga4_purchase(payment, ga_client_id)
        return if ga_client_id.blank?
    
        uri = URI("https://www.google-analytics.com/mp/collect?measurement_id=#{ENV['GA4_MEASUREMENT_ID']}&api_secret=#{ENV['GA4_API_SECRET']}")
    
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path + "?" + uri.query, { 'Content-Type' => 'application/json' })
        request.body = self.payload(payment, ga_client_id).to_json
        http.request(request)
    end

    def self.payload(payment, ga_client_id)
        {
            client_id: ga_client_id,
            events: [{
                name: "purchase",
                params: {
                transaction_id: payment.id.to_s,
                value: payment.amount.to_f / 100.0,
                currency: "USD",
                items: [{
                    item_name: payment.stripe_product_id || "Digital Product",
                    quantity: 1
                }]}
            }]
        }
    end
end