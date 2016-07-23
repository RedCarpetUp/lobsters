class CollcommentNotify < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(collcomment, application, job, user)
    @collcomment = collcomment
    @application = application
    @job = job

    mail(
      :to => user.email,
      :subject => "[#{Rails.application.name}] " <<
        "Comment posted on job application"
    )
  end
end
