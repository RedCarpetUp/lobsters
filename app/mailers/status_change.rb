class StatusChange < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(user, application, job)
    @user = user
    @application = application
    @job = job

    mail(
      :to => user.email,
      :subject => "[#{Rails.application.name}] " <<
        "Status change in job posting"
    )
  end
end
