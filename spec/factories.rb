FactoryGirl.define do
	factory :user do
		name	"Example User"
		character	"Foobar"
		email	"user@example.com"
		tera	true
		wow		true
		password	"foobar"
		password_confirmation	"foobar"
	end
end
