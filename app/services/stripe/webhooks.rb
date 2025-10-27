# Listen webhook locally https://stripe.com/docs/webhooks/test
# stripe listen --forward-to localhost:3000/stripe_webhook

class Stripe::Webhooks
    def webhooks(payload, webhook_secret, sig_header, event)
      if !webhook_secret.empty?
        begin
          event = Stripe::Webhook.construct_event(
            payload, sig_header, webhook_secret
          )
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
        
        binding.pry
        stripe_payment_intent = data["object"]["id"]
        amount = data["object"]["amount"]
        

        # checkout_session_id = data["object"]["id"]
        # client_reference_id = data["object"]["client_reference_id"]
        # stripe_customer = data["object"]["customer"]
        # user = User.find_by(id: client_reference_id) if client_reference_id.present?
        # user.update(stripe_customer: stripe_customer) if user.present?
    #   when "customer.subscription.created"
    #     # Occurs whenever a customer is signed up for a new plan.
    #     # Create subscription and save status.
    #     # https://stripe.com/docs/api/subscriptions/object#subscription_object-status
    #     # Possible values are incomplete, incomplete_expired, trialing, active, past_due, canceled, or unpaid.
  
    #     subscription_status = data["object"]["status"]
    #     subscription_id = data["object"]["id"]
    #     stripe_customer = data["object"]["customer"]
    #     subscription_item_id = data["object"]["items"]["data"][0]["id"]
    #     user = User.find_by(stripe_customer: stripe_customer) if stripe_customer.present?
    #     user.subscriptions.create(stripe_subscription: subscription_id, status: subscription_status, subscription_item_id: subscription_item_id) if user.present?
    #   when "customer.subscription.updated"
    #     # Update subscription status.
    #     # Possible values are incomplete, incomplete_expired, trialing, active, past_due, canceled, or unpaid.
    #     subscription_status = data["object"]["status"]
    #     subscription_id = data["object"]["id"]
    #     subscription = Subscription.find_by(stripe_subscription: subscription_id)
  
    #     subscription.update(status: subscription_status) if subscription.present?
  
    #     Rails.logger.error("=================== Event type: customer.subscription.updated ==================")
    #   when "customer.subscription.deleted"
    #     # When this event is triggered make sure you delete stripe_customer and stripe_payment_method ids.
    #     subscription_status = data["object"]["status"]
    #     subscription_id = data["object"]["id"]
    #     subscription = Subscription.find_by(stripe_subscription: subscription_id)
  
    #     if subscription.present?
    #       subscription.user.update(stripe_customer: nil, stripe_payment_method: nil)
    #       subscription.delete
    #     end
    #   when "payment_method.attached"
    #     # This events needed to get stripe_payment_method to charge card in the future.
    #     # Stripe::PaymentIntent.create({confirm: true, off_session: true, amount: 1000,
    #     # currency: 'usd', customer: "cus_NHiS9SYDnBd1WD", payment_method: "pm_1MX91AGR6gk9jaIRQXwDj0UO"})
  
    #     stripe_customer = data["object"]["customer"]
    #     payment_method = data["object"]["id"]
    #     user = User.find_by(stripe_customer: stripe_customer) if stripe_customer.present?
    #     user.update(stripe_payment_method: payment_method) if user.present? && payment_method.present?
      else
        # Display error message in logs when event.type is not handled.
        puts "Unhandled event type: #{event.type}"
        return true
      end
    end
  end