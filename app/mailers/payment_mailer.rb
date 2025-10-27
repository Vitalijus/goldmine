class PaymentMailer < ApplicationMailer
    default from: "vitalijus.desukas@smartroute.io"

    def download_email(payment)
      @payment = payment
      @url = "http://localhost:3000/pages/download?id=#{@payment.id}"
      mail(to: @payment.client_email, subject: "Download link")
    end
end
