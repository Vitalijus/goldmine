class WebhooksController < ApplicationController
  protect_from_forgery except: [:stripe_webhook] # Security issue???

  # Listen webhook locally https://stripe.com/docs/webhooks/test
  # stripe listen --forward-to localhost:3000/stripe_webhook
  def stripe_webhook
    payload = request.body.read
    webhook_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET")
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil

    webhooks = Stripe::Webhooks.new.webhooks(payload, webhook_secret, sig_header, event)
    webhooks ? head(:ok) : head(:bad_request)
  end
end