class Payment < ApplicationRecord
    after_create :send_download_email

    private

    def send_download_email
        # UserMailer.download_email(self).deliver_later
        Rails.logger.info("Email with download link sent to: #{email}")
    end
end
