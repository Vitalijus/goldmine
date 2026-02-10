require "sidekiq-scheduler"

class SampleSchedulerJob
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform
    new_companies_scope = Company.where("updated_at >= ?", 1.month.ago)
    return if new_companies_scope.none?

    Sample.find_each(batch_size: 500) do |sample|
      SampleJob.perform_async(sample.id)
    end
  end
end