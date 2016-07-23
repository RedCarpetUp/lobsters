class CollabsChange < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(change, user, changeduser, job)
    @user = user
    @changeduser = changeduser
    @job = job
    @change = change

    mail(
      :to => user.email,
      :subject => "[#{Rails.application.name}] " <<
        "Collaborator #{change}"
    )
  end
end
