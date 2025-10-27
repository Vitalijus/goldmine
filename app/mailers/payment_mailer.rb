class PaymentMailer < ApplicationMailer
    default from: "vitalijus.desukas@smartroute.io"

    def download_email(payment)
      @payment = payment
      @url  = "https://yourapp.com/login"
      mail(to: @payment.client_email, subject: "Download link")
    end
end
