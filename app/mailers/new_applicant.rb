class NewApplicant < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(user, appl, job)
    @user = user
    @appl = appl
    @job = job

    mail(
      :to => user.email,
      :subject => "[#{Rails.application.name}] " <<
        "New applicant on job #{job.title}"
    )
  end
end
