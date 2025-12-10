# Prices and ranges can be changed only after Stripe products are created
# and config ENV are propagated

module Pricing
  def self.price_rates
    [
      {
          total_companies: 0..49,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_0_49'),
          price: 5000
      },
      {
          total_companies: 50..149,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_50_149'),
          price: 10000
      },
      {
          total_companies: 150..249,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_150_249'),
          price: 15000
      },
      {
          total_companies: 250..349,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_250_349'),
          price: 20000
      },
      {
          total_companies: 350..449,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_350_449'),
          price: 25000
      },
      {
          total_companies: 450..Float::INFINITY,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_450'),
          price: 50000
      }
    ]
  end
end
