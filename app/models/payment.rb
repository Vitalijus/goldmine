class Payment < ApplicationRecord
    # TO DO add validations

    # after_commit guarantees the job only runs after the Payment has been saved to the DB.
    after_commit :send_download_email, on: :create

    private

    def send_download_email
        # A known issue if mailer is set to async deliver_later it gives an error:
        # PG::UndefinedTable: ERROR:  relation "solid_queue_processes"
        # does not exist (ActiveRecord::StatementInvalid
        # Run bundle exec rake solid_queue:start
        # Need to fix solid_queue if want to send email async!!
        PaymentMailer.download_email(self).deliver_now
        Rails.logger.info("Email with download link sent to: #{self.client_email}")
    end
end
