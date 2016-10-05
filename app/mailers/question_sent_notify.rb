class QuestionSentNotify < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(applquestion, appl)
    @application = appl
    @applquestion = applquestion

    mail(
      :to => appl.email,
      :subject => "[#{Rails.application.name}] " <<
        "New question on job #{appl.job.title}"
    )
  end
end
