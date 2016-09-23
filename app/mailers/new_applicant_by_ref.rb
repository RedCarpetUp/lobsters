class NewApplicantByRef < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(to_email, appl, job)
    @to_email = to_email
    @appl = appl
    @job = job

    mail(
      :to => to_email,
      :subject => "[#{Rails.application.name}] " <<
        "New applicant on job #{job.title} by your reference"
    )
  end
end
