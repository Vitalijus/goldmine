require 'rails_helper'

RSpec.describe "Webhooks", type: :request do
  describe "GET /stripe_webhook" do
    it "returns http success" do
      get "/webhooks/stripe_webhook"
      expect(response).to have_http_status(:success)
    end
  end

end
