require 'spec_helper'

describe "ArticlePages" do
  
	subject { page }

	let(:user) { FactoryGirl.create(:member) }
	before { sign_in user }

	describe "article creation" do
		before { visit root_path }

		describe "with invalid information" do
			it "should not create an article" do
				expect { click_button "Post" }.should_not change(Article, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			describe "with wow checked" do
				before do
					fill_in 'Title',		with: "Title"
					fill_in 'Content',	with: "Content"
					check 'WoW'
				end
				it "should create a wow article" do
					expect { click_button "Post" }.should change(Article.where(wow: true), :count).by(1)
				end
			end
			describe "with tera checked" do
				before do
					fill_in 'Title',		with: "Title"
					fill_in 'Content',	with: "Content"
					check 'TERA'
				end
				it "should create a tera article" do
					expect { click_button "Post" }.should change(Article.where(tera: true), :count).by(1)
				end
			end
		end
	end

	describe "article destruction" do
		before { FactoryGirl.create(:article, user: user, wow: true) }

		describe "as correct user" do
			before do
				visit root_path
			end

			it "should delete the article" do
				expect { click_link "delete" }.should change(Article, :count).by(-1)
			end
		end

		describe "as admin" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				sign_in admin
				visit root_path
			end

			it "should delete the article" do
				expect { click_link "delete" }.should change(Article, :count).by(-1)
			end
		end
	end
end
