class Payment < ApplicationRecord
    after_create :send_download_email

    private

    def send_download_email
        # PaymentMailer.download_email(self).deliver_later
        # Rails.logger.info("Email with download link sent to: #{self.client_email}")
    end
end
