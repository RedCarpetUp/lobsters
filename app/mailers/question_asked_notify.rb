class QuestionAskedNotify < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(applquestion, appl, touser)
    @user = touser
    @application = appl
    @applquestion = applquestion

    mail(
      :to => touser.email,
      :subject => "[#{Rails.application.name}] " <<
        "Question asked from applicant on job #{appl.job.title}"
    )
  end
end
