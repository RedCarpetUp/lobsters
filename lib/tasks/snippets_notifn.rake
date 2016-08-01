namespace :snippets_notifn do
  desc "Send emails to all users who are are part of any organisation to update their snipets since week is about to end, has to be triggered near end of a work week"
  task send_mails: :environment do
  	Organisation.all.each do |org|
  		SnipReminder.notify(org.owner.id, org.id).deliver
  		org.users.each do |us|
  			SnipReminder.notify(us.id, org.id).deliver
  		end
  	end
  end
end
