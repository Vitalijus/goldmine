class SampleMailer < ApplicationMailer
    helper :samples
    helper :pages
    default from: "gemscraper.com <company@gemscraper.com>"

    def download_sample_email(sample)
      @sample = sample
      mail(to: @sample.email, subject: "Free sample of companies hiring your tech stack")
    end
end
