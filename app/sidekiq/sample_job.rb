class SampleJob
  include Sidekiq::Job
  sidekiq_options queue: :mailers, retry: 5

  def perform(sample_id)
    sample = Sample.find_by(id: sample_id)
    return unless sample
    # Guard to prevent duplicate emails
    return if sample.updated_at && sample.updated_at > 1.month.ago

    SampleMailer.updated_sample_email(sample).deliver_now
    
    # Update the sample's updated_at timestamp to prevent sending multiple emails for the same sample
    sample.update(updated_at: Time.current)
  end
end
