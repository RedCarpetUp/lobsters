namespace :tags_seed do
	desc "Add new tags to the application, or remove tags from application."
	task add: :environment do
		new_tags_list = [{ name: "android", description: 	"Android" },
						 { name: "api", description: 	"API development/implementation" },
						 { name: "art", description: 	"Art" },
						 { name: "ask", description: 	"Ask Hackergully" },
						 { name: "assembly", description: 	"Assembly programming" },
						 { name: "audio", description: 	"Link to audio (podcast, interview)" },
						 { name: "book", description: 	"Books" },
						 { name: "browsers", description: 	"Web browsers" },
						 { name: "c", description: 	"C, C++, Objective C programming" },
						 { name: "cogsci", description: 	"Cognitive Science" },
						 { name: "compilers", description: 	"Compiler design" },
						 { name: "compsci", description: 	"Other computer science/programming" },
						 { name: "crypto", description: 	"Cryptography" },
						 { name: "cryptocurrencies", description: 	"Bitcoin and other cryptocurrencies" },
						 { name: "culture", description: 	"Technical communities and culture" },
						 { name: "databases", description: 	"Databases (SQL, NoSQL)" },
						 { name: "debugging", description: 	"Debugging techniques" },
						 { name: "design", description: 	"Visual design" },
						 { name: "devops", description: 	"DevOps" },
						 { name: "distributed", description: 	"Distributed systems" },
						 { name: "dotnet", description: 	"C#, F#, .NET programming" },
						 { name: "elixir", description: 	"Elixir language" },
						 { name: "emacs", description: 	"Emacs editor" },
						 { name: "erlang", description: 	"Erlang development" },
						 { name: "event", description: 	"Events, conferences, and meetups" },
						 { name: "finance", description: 	"Finance and economics" },
						 { name: "freebsd", description: 	"FreeBSD" },
						 { name: "games", description: 	"Game design and study" },
						 { name: "go", description: 	"Go programming" },
						 { name: "graphics", description: 	"Graphics programming" },
						 { name: "hardware", description: 	"Hardware" },
						 { name: "haskell", description: 	"Haskell programming" },
						 { name: "historical", description: 	"Tech history" },
						 { name: "ios", description: 	"Apple iOS" },
						 { name: "java", description: 	"Java programming" },
						 { name: "javascript", description: 	"Javascript programming" },
						 { name: "job", description: 	"Employment/Internship opportunities" },
						 { name: "law", description: 	"Law" },
						 { name: "linux", description: 	"Linux" },
						 { name: "lisp", description: 	"Lisp programming" },
						 { name: "lua", description: 	"Lua programming" },
						 { name: "mac", description: 	"Apple Mac OS X" },
						 { name: "math", description: 	"Mathematics" },
						 { name: "meta", description: 	"Hackergully-related bikeshedding" },
						 { name: "ml", description: 	"ML, OCaml programming" },
						 { name: "mobile", description: 	"Mobile app/web development" },
						 { name: "netbsd", description: 	"NetBSD" },
						 { name: "networking", description: 	"Networking" },
						 { name: "openbsd", description: 	"OpenBSD" },
						 { name: "pdf", description: 	"Link to a PDF document" },
						 { name: "perl", description: 	"Perl" },
						 { name: "person", description: 	"Stories about particular persons" },
						 { name: "philosophy", description: 	"Philosophy" },
						 { name: "php", description: 	"PHP programming" },
						 { name: "practices", description: 	"Development and business practices" },
						 { name: "privacy", description: 	"Privacy" },
						 { name: "programming", description: 	"General software development" },
						 { name: "python", description: 	"Python programming" },
						 { name: "rant", description: 	"Rants and raves" },
						 { name: "reversing", description: 	"Reverse engineering" },
						 { name: "ruby", description: 	"Ruby programming" },
						 { name: "rust", description: 	"Rust language" },
						 { name: "satire", description: 	"Satirical writing" },
						 { name: "scala", description: 	"Scala programming" },
						 { name: "scaling", description: 	"Scaling and architecture" },
						 { name: "science", description: 	"Science" },
						 { name: "security", description: 	"Netsec, appsec, and infosec" },
						 { name: "show", description: 	"Show Hackergully / Projects" },
						 { name: "slides", description: 	"Slide deck" },
						 { name: "software", description: 	"Software releases and announcements" },
						 { name: "swift", description: 	"Swift programming" },
						 { name: "systemd", description: 	"Linux systemd" },
						 { name: "testing", description: 	"Software testing" },
						 { name: "unix", description: 	"*nix" },
						 { name: "vcs", description: 	"Git and other version control systems" },
						 { name: "video", description: 	"Link to a video" },
						 { name: "vim", description: 	"Vim editor" },
						 { name: "virtualization", description: 	"Virtualization" },
						 { name: "visualization", description: 	"Data visualization" },
						 { name: "web", description: 	"Web development and news" },
						 { name: "windows", description: 	"Windows operating system" },
						 { name: "bangalore", description: 	"Tech capital of India" },
						 { name: "delhi", description: 	"Capital of India" },
						 { name: "mumbai", description: 	"The capital of Maharashtra" },
						 { name: "pune", description: 	"A city in Maharashtra" },
						 { name: "hyderabad", description: 	"The capital of Telangana" },
						 { name: "chennai", description: 	"The capital of Tamil Nadu" }]
		new_tags_list.each do |thetag|
			if Tag.where(:tag => thetag[:name] ).blank?
				modtag = Tag.new
				modtag.tag = thetag[:name]
				modtag.description = thetag[:description]
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

	task inactive: :environment do
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