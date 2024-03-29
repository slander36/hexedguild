require 'spec_helper'

describe "Authentication" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_selector('h1',
			text: "Sign In") }
		it { should have_selector('title',
			text: "Sign In") }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign In" }

			it { should have_selector('title',
				text: "Sign In") }
			it { should have_selector('div.alert.alert-error',
				text: "Invalid") }

			describe 'after visiting another page' do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
			end

			it { should have_selector('title',
				text: user.character) }
			
			it { should have_link('Members',
				href: members_path) }
			it { should have_link('Profile',
				href: member_path(user.character)) }
			it { should have_link('Settings',
				href: edit_member_path(user.character)) }
			it { should have_link('Sign Out',
				href: signout_path) }
			
			it { should_not have_link('Sign In',
				href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign Out" }
				it { should have_link("Sign In") }
			end
		end
	end

	describe "authorization" do
		let(:user) { FactoryGirl.create(:user) }

		describe "in the Users controllers" do

			describe "visiting the edit page" do
				before { visit edit_member_path(user) }
				it { should have_selector('title',
					text: "Sign In") }
			end

			describe "submitting to the update action" do
				before { put member_path(user) }
				specify { response.should redirect_to(signin_path) }
			end

			describe "visiting the user index" do
				before { visit users_path }
				it { should have_selector('title',
					text: "Sign In") }
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user }

			describe "visiting Users#edit page" do
				before { visit edit_member_path(wrong_user) }
				it { should_not have_selector('title', text: full_title('Edit User')) }
			end

			describe "submitting a PUT request to the Users#update action" do
				before { put member_path(wrong_user) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end

	describe "authorization" do
		
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_member_path(user.character)
					fill_in "Email",				with: user.email
					fill_in "Password",			with: user.password
					click_button "Sign In"
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						page.should have_selector('title',
							text: "Edit User")
					end
				end
			end

			describe "in the Articles controller" do
				
				describe "submitting to the create action" do
					before { post articles_path }
					specify { response.should redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before do
						article = FactoryGirl.create(:article)
						delete article_path(article)
					end
					specify { response.should redirect_to(signin_path) }
				end
			end
		end

		describe "as a non-member user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_member) { FactoryGirl.create(:user) }

			before { sign_in non_member }

			describe "submitting a GET request to the Users#show action" do
				before { get member_path(user.character) }
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin }

			describe "submitting a DELETE request to the Unsers#destroy action" do
				before { delete member_path(user.character) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end
