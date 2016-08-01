class SnipReminder < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(user_id, org_id)
    @user = User.find(user_id)
    @organisation = Organisation.find(org_id)

    mail(
      :to => @user.email,
      :subject => "[#{Rails.application.name}] " <<
        "Snippets update reminder"
    )
  end
end
