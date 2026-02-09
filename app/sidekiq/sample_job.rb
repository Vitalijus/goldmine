class SampleJob
  include Sidekiq::Job
  sidekiq_options queue: :mailers, retry: 5

  def perform(sample_id)
    sample = Sample.find_by(id: sample_id)
    return unless sample
  
    SampleMailer.updated_sample_email(sample).deliver_now
  end
end
