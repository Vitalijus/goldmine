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
      when  "checkout.session.completed"
        client_reference_id = data&.object&.client_reference_id
        stripe_payment_intent = data&.object&.payment_intent
        amount = data&.object&.amount_total
        client_email = data&.object&.customer_details&.email
        status = data&.object&.status

        payment = Payment.find(client_reference_id)
        payment_intent_data = Stripe::RetrievePaymentIntent.new(payment_intent_id: stripe_payment_intent)
        payment_intent = payment_intent_data.retrieve

        if payment.present? && status == "complete" && payment_intent.present?
          stripe_product_id = payment_intent&.payment_details&.order_reference

          update_payment = payment.update(
            stripe_payment_intent: stripe_payment_intent,
            amount: amount,
            client_email: client_email,
            stripe_product_id: stripe_product_id
          )

          Rails.logger.info("=================== Event type: checkout.session.completed ==================")
        else
          Rails.logger.error("=================== Event type ERROR: checkout.session.completed ==================")
        end
      else
        # Display error message in logs when event.type is not handled.
        puts "Unhandled event type: #{event.type}"
        return true
      end
    end
  end
