namespace :tags_seed do
	desc "Add new tags to the application, or remove tags from application."
	task add: :environment do
		new_tags_list = ["Tag1", "Tag2", "Tag3", "Tag4", "Tag5", "Tag6"]
		new_tags_list.each do |thetag|
			if Tag.where(:tag => thetag ).blank?
				modtag = Tag.new
				modtag.tag = thetag
				if modtag.save
					puts "New tag '#{thetag}' created"
				else
					puts "Could not create new tag '#{thetag}'"
				end
			else
				chngtag = Tag.where(:tag => thetag ).first
				if chngtag.inactive == true
					chngtag.inactive = false
					if chngtag.save
						puts "'#{thetag}' exists but inactive, activating tag"
					else
						puts "'#{thetag}' exists but inactive, failed to activate"
					end
				else
					puts "Skipping creating tag '#{thetag}', already exists and active"
				end
			end
		end
	end

	task remove: :environment do
		rem_tags_list = ["Tag1", "Tag2", "Tag3", "Tag4", "Tag6", "Tag7"]
		rem_tags_list.each do |thetag|
			if !Tag.where(:tag => thetag ).blank?
				modtag = Tag.where(:tag => thetag ).first
				if modtag.inactive == false
					modtag.inactive = true
					if modtag.save
						puts "Existing tag '#{thetag}' made inactive"
					else
						puts "Could not inactive existing tag '#{thetag}'"
					end
				else
					puts "'#{thetag}' exists and is already inactive"
				end
			else
				puts "Skipping removing tag '#{thetag}', does not exists"
			end
		end
	end

end