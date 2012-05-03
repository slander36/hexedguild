require 'spec_helper'

describe "User pages" do
	
	subject { page }

	describe "application page" do
		before { visit apply_path }

		it { should have_selector('h1',
			text: "Application") }
		it { should have_selector('title',
			text: full_title("Apply")) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1',
			text: user.name) }
		it { should have_selector('title',
			text: user.name) }
	end

	describe "apply" do
		before { visit apply_path }

		let(:submit) { "Apply" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "error messages" do
				before { click_button submit }

				it { should have_selector('title',
					text: 'Apply') }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in	"Name",					with: "Example User"
				fill_in "Character",		with: "Foobar"
				fill_in "Email",				with: "user@example.com"
				fill_in "Password", 		with: "foobar"
				fill_in "Confirmation",	with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by_email("user@example.com") }

				it { should have_selector('title',
					text: user.name) }
				it { should have_selector('div.alert.alert-success',
					text: "Welcome") }
				it { should have_link('Sign out',
					href: signout_path) }
			end
		end
	end
end
