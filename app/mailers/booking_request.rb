class BookingRequest < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(requestee, requester)
    @requestee = requestee
    @requester = requester

    mail(
      :to => requestee.email,
      :subject => "[#{Rails.application.name}] " <<
        "Meeting request received"
    )
  end
end
