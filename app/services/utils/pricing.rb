module Pricing
  def self.price_rates
    [
      {
          total_companies: 0..49,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_USA'),
          price: 5000
      },
      {
          total_companies: 50..150,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_USA'),
          price: 10000
      },
      {
          total_companies: 151..250,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_USA'),
          price: 15000
      },
      {
          total_companies: 251..350,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_USA'),
          price: 20000
      },
      {
          total_companies: 351..450,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_USA'),
          price: 25000
      },
      {
          total_companies: 451..Float::INFINITY,
          stripe_payment_link: ENV.fetch('STRIPE_PAYMENT_LINK_USA'),
          price: 50000
      }
    ]
  end
end
