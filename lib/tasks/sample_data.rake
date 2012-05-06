namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example Admin",
			character: "Admin",
			email: "admin@hexedguild.com",
			password: "foobar",
			password_confirmation: "foobar")
		admin.toggle!(:admin)
		admin.toggle!(:member)
	
		60.times do |n|
			name = Faker::Name.name
			character = "Member#{n+1}"
			email = "member-#{n+1}@hexedguild.com"
			password = "password"
			member = User.create!(name: name,
				character: character,
				email: email,
				password: password,
				password_confirmation: password)
			member.toggle!(:member)
		end

		20.times do |n|
			name = Faker::Name.name
			character = "Recruit#{n+1}"
			email = "recruit-#{n+1}@hexedguild.com"
			password = "password"
			User.create!(name: name,
				character: character,
				email: email,
				password: password,
				password_confirmation: password)
		end
	end
end
