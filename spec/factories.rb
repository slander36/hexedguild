FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:character) { |n| "Character #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password	"foobar"
		password_confirmation	"foobar"

		factory :member do
			member true
		end

		factory :admin do
			member true
			admin true
		end
	end

	factory :wow_toon do
		name "Deathwing"
		user
	end

	factory :tera_toon do
		name "Eilin"
		user
	end
end
