# Listen webhook locally https://stripe.com/docs/webhooks/test
# stripe listen --forward-to localhost:3000/stripe_webhook

class Stripe::Webhooks
    def webhooks(payload, webhook_secret, sig_header, event)
      if !webhook_secret.empty?
        begin
          event = Stripe::Webhook.construct_event(payload, sig_header, webhook_secret)
        rescue JSON::ParserError => e
          # Invalid payload
          Rails.logger.error("=================== JSON::ParserError #{e.error} ==================")
          return
        rescue Stripe::SignatureVerificationError => e
          # Invalid signature
          Rails.logger.error("=================== Stripe::SignatureVerificationError #{e.error} ==================")
          return
        end
      else
        data = JSON.parse(payload, symbolize_names: true)
        event = Stripe::Event.construct_from(data)
      end
  
      # Get the type of webhook event sent
      event_type = event["type"]
      data = event["data"]
  
      # Handle the event
      case event_type
      when  "payment_intent.succeeded"
        # https://docs.stripe.com/api/events/types#event_types-payment_intent.succeeded
        stripe_payment_intent = data["object"]["id"]
        amount = data["object"]["amount"]
        # stripe_product_id = data["object"]["payment_details"]["order_reference"]
        # client_email = data["object"]["charges"]["data"][0]["email"]
        
        # binding.pry
        Payment.create(stripe_payment_intent: stripe_payment_intent, amount: amount)
        Rails.logger.info("=================== Event type: payment_intent.succeeded ==================")
      else
        # Display error message in logs when event.type is not handled.
        puts "Unhandled event type: #{event.type}"
        return true
      end
    end
  end