require 'spec_helper'

describe "User pages" do
	
	subject { page }

	describe "index" do

		let(:user) { FactoryGirl.create(:user) }

		before do
			sign_in user
			visit members_path
		end

		it { should have_selector('title',
			text: 'All Members') }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }

			it { should have_link('Next') }
			its(:html) { should match('>2</a>') }

			it "should list each user" do
				User.all[0..2].each do |user|
					page.should have_selector('li',
						text: user.character)
				end
			end
		end

		describe "view link" do

			before(:all) { 10.times { FactoryGirl.create(:user) } }
			before(:all) { 10.times { FactoryGirl.create(:member) } }
			before(:all) { 2.times { FactoryGirl.create(:admin) } }
			after(:all) { User.delete_all }

			let(:test) { FactoryGirl.create(:user) }

			it { should_not have_link('View',
				href: member_path(User.first.character)) }

			shared_examples_for "a member" do
				it { should have_link('View',
					href: member_path(User.first.character)) }
				describe "click link" do
					before do
						click_link "View"
					end
					it { should have_selector('title',
						href: User.first.character) }
				end
			end

			describe "as a member" do
				let(:member) { FactoryGirl.create(:member) }
				before do
					sign_in member
					visit members_path
				end

				it_should_behave_like "a member"
			end

			describe "as an admin" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit members_path
				end

				it_should_behave_like "a member"
			end
		end

		describe "confirm link" do

			before(:all) { 10.times { FactoryGirl.create(:user) } }
			before(:all) { 10.times { FactoryGirl.create(:member) } }
			before(:all) { 2.times { FactoryGirl.create(:admin) } }
			after(:all) { User.delete_all }

			let(:test) { FactoryGirl.create(:user) }

			it { should_not have_link('Confirm',
				href: member_path(User.first.character)) }

			describe "as an admin" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit members_path
				end
				
				it { should have_link('Confirm') }
				describe "click confirm" do
					before do
						click_link 'Confirm'
					end
					it { should have_selector('div.alert.alert-success') }
				end
			end
		end

		describe "delete link" do

			before(:all) { 10.times { FactoryGirl.create(:user) } }
			before(:all) { 10.times { FactoryGirl.create(:member) } }
			before(:all) { 2.times { FactoryGirl.create(:admin) } }
			after(:all) { User.delete_all }

			let(:test) { FactoryGirl.create(:user) }
			
			it { should_not have_link('Delete',
				href: member_path(User.first.character)) }

			describe "as an admin" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit members_path
				end

				it { should have_link('Delete') }
				it "should be able to delete another user" do
					expect { click_link('Delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('Delete',
					href: member_path(admin.character)) }
			end
		end
	end

	describe "application page" do
		before { visit apply_path }

		it { should have_selector('h1',
			text: "Application") }
		it { should have_selector('title',
			text: full_title("Apply")) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:member) }
		let!(:a1) do
			FactoryGirl.create(:article,
				user: user,
				title: "Foo Title",
				content: "Foo Content",
				wow: true)
		end
		let!(:a2) do
			FactoryGirl.create(:article,
				user: user,
				title: "Bar Title",
				content: "Bar Content",
				tera: true)
		end
		before do
			sign_in user
			visit member_path(user.character)
		end

		it { should have_selector('h1',
			text: user.character) }
		it { should have_selector('title',
			text: user.character) }

		describe "article" do
			it { should have_content(a1.title) }
			it { should have_content(a1.content) }
			it { should have_content(a2.title) }
			it { should have_content(a2.content) }
			it { should have_content(user.articles.count) }
		end
	end

	describe "admin profile page" do
		let(:user) { FactoryGirl.create(:admin) }
		let!(:a1) do
			FactoryGirl.create(:article,
				user: user,
				title: "Foo Title",
				content: "Foo Content",
				wow: true,
				announcement: true)
		end
		let!(:a2) do
			FactoryGirl.create(:article,
				user: user,
				title: "Bar Title",
				content: "Bar Content",
				tera: true)
		end

		before do
			sign_in user
			visit user_path(user)
		end

		it { should have_selector('h1',
			text: user.character) }
		it { should have_selector('title',
			text: user.character) }

		describe "article" do
			it { should have_content(a1.title) }
			it { should have_content(a1.content) }
			it { should have_content(a2.title) }
			it { should have_content(a2.content) }
			it { should have_content(user.articles.count) }
		end

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
				check 	"WoW"
				check		"TERA"
				fill_in	"Application",	with: "This is an application"
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
					text: user.character) }
				it { should have_selector('div.alert.alert-success',
					text: "Welcome") }
				it { should have_link('Sign Out',
					href: signout_path) }
			end
		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_member_path(user.character)
		end

		describe "page" do
			it { should have_selector('h1',
				text: "Update your profile") }
			it { should have_selector('title',
				text: "Edit User") }
		end

		describe "with invalid information" do
			before { click_button "Save Changes" }

			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_character) { "New Character" }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Name",					with: new_name
				fill_in "Character",		with: new_character
				fill_in "Email",				with: new_email
				fill_in "Password",			with: user.password
				fill_in "Confirmation",	with: user.password
				click_button "Save Changes"
			end

			it { should have_selector('title',
				text: new_character) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign Out',
				href: signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.character.should == new_character }
			specify { user.reload.email.should == new_email }
		end
	end
end
