class Applicant < ApplicationRecord
  belongs_to :career
  has_one_attached :resume

  # after_commit guarantees the job only runs after the Payment has been saved to the DB.
  after_commit :send_new_applicant_email, on: :create
  after_commit :store_resume_url, on: [:create, :update]

  validates :name, :surname, :email, :country, :city, :resume, presence: true

  private

  def store_resume_url # TO DO validate for pdf or doc file, and size
    return unless resume.attached?

    url = Rails.application.routes.url_helpers.url_for(resume)
    update_column(:resume, url)
  end

  def send_new_applicant_email
      # A known issue if mailer is set to async deliver_later it gives an error:
      # PG::UndefinedTable: ERROR:  relation "solid_queue_processes"
      # does not exist (ActiveRecord::StatementInvalid
      # Run bundle exec rake solid_queue:start
      # Need to fix solid_queue if want to send email async!!
      ApplicantMailer.new_applicant_email(self).deliver_now
      Rails.logger.info("New applicant is created and email sent to: #{self.email}")
  end
end
