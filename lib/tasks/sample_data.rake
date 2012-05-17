namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example Admin",
			character: "GM",
			email: "gm@hexedguild.com",
			wow: true,
			tera: true,
			apply: "I'm the GM",
			password: "foobar",
			password_confirmation: "foobar")
		admin.toggle!(:admin)
		admin.toggle!(:member)
	
		60.times do |n|
			name = Faker::Name.name
			character = "Member#{n+1}"
			email = "member-#{n+1}@hexedguild.com"
			wow = ( n % 2 == 0 ? true : false )
			tera = ( n % 3 == 0 ? true : false )
			unless wow or tera
				wow = true
			end
			apply = "I'm a member"
			password = "password"
			member = User.create!(name: name,
				character: character,
				email: email,
				wow: wow,
				tera: tera,
				apply: apply,
				password: password,
				password_confirmation: password)
			member.toggle!(:member)
		end

		20.times do |n|
			name = Faker::Name.name
			character = "Recruit#{n+1}"
			email = "recruit-#{n+1}@hexedguild.com"
			wow = ( n % 2 == 0 ? true : false )
			tera = ( n % 3 == 0 ? true : false )
			unless wow or tera
				wow = true
			end
			apply = "I'm an applicant"
			password = "password"
			User.create!(name: name,
				character: character,
				email: email,
				wow: wow,
				tera: tera,
				apply: apply,
				password: password,
				password_confirmation: password)
		end
	end
end
