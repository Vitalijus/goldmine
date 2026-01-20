class ApplicantMailer < ApplicationMailer
  helper :pages
  default from: "gemscraper.com <company@gemscraper.com>"

  def new_applicant_email(applicant)
    @applicant = applicant
    mail(to: @applicant.email, subject: "Thank you for applying!")
  end
end
