module Stripe
  class RetrievePaymentIntent
    attr_reader :payment_intent_id

    def initialize(payment_intent_id:)
      @payment_intent_id = payment_intent_id
    end

    def retrieve
      begin
        Stripe::PaymentIntent.retrieve(@payment_intent_id)
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error("=================== Stripe::InvalidRequestError: #{e.message} ==================")
        {}
      rescue Stripe::StripeError => e
        Rails.logger.error("=================== Stripe::StripeError: #{e.message} ==================")
        {}
      end
    end
  end
end
