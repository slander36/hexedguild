require 'spec_helper'

describe "Static pages" do

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('h1',
			text: heading) }
		it { should have_selector('title',
			text: full_title(page_title)) }
	end

	describe "Home page" do

		before { visit root_path }
		let(:heading) { 'Hexed Guild' }
		let(:page_title) { '' }

		it_should_behave_like "all static pages"
		it { should_not have_selector 'title',
			text: "| Home" }

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:article, user: user, wow: true, title: "Post 1")
				FactoryGirl.create(:article, user: user, tera: true, title: "Post 2")
				sign_in user
				visit root_path
			end

			it "should render the user's articles" do
				user.articles.limit(20) do |item|
					page.should have_selector("li##{item.id}", text: item.title)
				end
			end

			it "should not render members only articles" do
				
			end
		end
	end

	describe "Help page" do

		before { visit help_path }
		let(:heading) { "Help" }
		let(:page_title) { "Help" }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do

		before { visit contact_path }
		let(:heading) { "Contact" }
		let(:page_title) { "Contact" }

		it_should_behave_like "all static pages"
	end

	describe "About page" do

		before { visit about_path }
		let(:heading) { "About Hexed" }
		let(:page_title) { "About Hexed" } 

		it_should_behave_like "all static pages"
	end

	describe "TERA page" do
		
		before { visit tera_path }
		let(:heading) { "TERA" }
		let(:page_title) { "TERA" }

		it_should_behave_like "all static pages"
	end

	describe "WoW page" do
		
		before { visit wow_path }
		let(:heading) { "WoW" }
		let(:page_title) { "WoW" }

		it_should_behave_like "all static pages"
	end
end
