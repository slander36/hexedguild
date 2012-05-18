# == Schema Information
#
# Table name: articles
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  content      :string(255)
#  wow          :boolean
#  tera         :boolean
#  announcement :boolean
#  user_id      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe Article do
  
	let(:user) { FactoryGirl.create(:member) }

	before do
		@art = user.articles.build(title: 'title',
			content: 'lorem ipsum',
			wow: true,
			tera: true,
			announcement: true)
	end

	subject { @art }

	it { should respond_to(:content) }
	it { should respond_to(:wow) }
	it { should respond_to(:tera) }
	it { should respond_to(:announcement) }
	it { should respond_to(:user) }
	its(:user) { should == user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @art.user_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Article.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "with content that is too long" do
		before { @art.content = "a" * 5001 }
		it { should_not be_valid }
	end

	describe "without wow or tera checked" do
		before do
			@art.wow = false
			@art.tera = false
		end
		it { should_not be_valid }
	end
end
