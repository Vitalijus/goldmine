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
        stripe_payment_intent = data&.object&.id
        amount = data&.object&.amount
        stripe_product_id = data&.object&.payment_details&.order_reference
        client_email = data&.object&.charges&.data&.first&.billing_details&.email
      
        Payment.create(
          stripe_payment_intent: stripe_payment_intent,
          amount: amount,
          client_email: client_email,
          stripe_product_id: stripe_product_id
        )

        Rails.logger.info("=================== Event type: payment_intent.succeeded ==================")
      when  "checkout.session.completed"
        client_reference_id = data&.object&.client_reference_id
        stripe_payment_intent = data&.object&.payment_intent

        params = Payment.find(client_reference_id)
        payment = Payment.find_by(stripe_payment_intent: stripe_payment_intent)

        if params && payment
          update_payment = payment.update(
            countries: params[:countries] || [],
            cities: params[:cities] || [],
            programming_languages: params[:programming_languages] || [],
            frameworks: params[:frameworks] || [],
            other_tech_stack: params[:other_tech_stack] || [],
            remote: params[:remote] || nil
          )

          params.delete if update_payment
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
