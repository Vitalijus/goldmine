class PaymentMailer < ApplicationMailer
    default from: "gemscraper.com <company@gemscraper.com>"


    def download_email(payment)
      @payment = payment
      @url = ENV.fetch("LIST_DOWNLOAD_URL") + "download?id=#{@payment.id}"
      mail(to: @payment.client_email, subject: "Download link")
    end
end
