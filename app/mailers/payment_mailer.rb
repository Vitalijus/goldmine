class PaymentMailer < ApplicationMailer
    default from: "vitalijus.desukas@smartroute.io"

    def download_email(payment)
      @payment = payment
      @url = ENV.fetch("LIST_DOWNLOAD_URL") + "download?id=#{@payment.id}"
      mail(to: @payment.client_email, subject: "Download link")
    end
end
