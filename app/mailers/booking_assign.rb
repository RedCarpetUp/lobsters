class BookingAssign < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(requestee, requester, request)
    @requestee = requestee
    @requester = requester
    @request = request

    mail(
      :to => requester.email,
      :subject => "[#{Rails.application.name}] " <<
        "Meeting request accepted"
    )
  end
end
