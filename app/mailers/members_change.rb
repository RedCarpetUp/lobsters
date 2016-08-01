class MembersChange < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(change, user, changeduser, organisation)
    @user = user
    @changeduser = changeduser
    @organisation = organisation
    @change = change

    mail(
      :to => @user.email,
      :subject => "[#{Rails.application.name}] " <<
        "Member #{change}"
    )
  end
end
