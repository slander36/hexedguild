require 'spec_helper'

describe "Static pages" do

	describe "Home page" do
		
		it "should have the content 'Hexed Guild'" do
			visit root_path
			page.should have_content('Hexed Guild')
		end
	end

	describe "Help page" do
		
		it "should have the content 'Help'" do
			visit help_path
			page.should have_content('Help')
		end
	end

	describe "Contact page" do
		
		it "should have the content 'Contact'" do
			visit contact_path
			page.should have_content('Contact')
		end
	end

	describe "About page" do
		
		it "should have the content 'About Hexed'" do
			visit about_path
			page.should have_content('About Hexed')
		end
	end
end
