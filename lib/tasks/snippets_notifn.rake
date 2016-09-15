namespace :snippets_notifn do
  desc "Send emails to all users who are are part of any organisation to update their snipets since week is about to end, has to be triggered near end of a work week"
  task send_mails: :environment do
    if Time.now.strftime("%w") == "5"
  	  Organisation.all.each do |org|
  		  SnipReminder.notify(org.owner.id, org.id).deliver#.deliver_later
  		  org.users.each do |us|
  			  SnipReminder.notify(us.id, org.id).deliver#.deliver_later
  		  end
  	  end
      puts "Emailed, today is Friday"
    else
      puts "Not UTC Friday, skipping"
    end
  end
end
