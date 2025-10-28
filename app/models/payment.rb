class Payment < ApplicationRecord
    # after_commit guarantees the job only runs after the Payment has been saved to the DB.
    after_commit :send_download_email, on: :create

    private

    def send_download_email
        PaymentMailer.download_email(self).deliver_later
        Rails.logger.info("Email with download link sent to: #{self.client_email}")
    end
end
