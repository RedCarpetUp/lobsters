class QuestionAnsweredNotify < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(applquestion, appl, touser)
    @user = touser
    @application = appl
    @applquestion = applquestion

    mail(
      :to => touser.email,
      :subject => "[#{Rails.application.name}] " <<
        "Applicant answered on job #{appl.job.title}"
    )
  end
end
