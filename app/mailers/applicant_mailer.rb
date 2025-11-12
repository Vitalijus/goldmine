class ApplicantMailer < ApplicationMailer
  helper :pages
  default from: "rorlist.com <support@rorlist.com>"

  def new_applicant_email(applicant)
    @applicant = applicant
    mail(to: @applicant.email, subject: "Thank you for applying!")
  end
end
