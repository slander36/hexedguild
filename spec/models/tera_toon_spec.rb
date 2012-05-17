# == Schema Information
#
# Table name: tera_toons
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe TeraToon do
  
	let(:user) { FactoryGirl.create(:user) }

	before { @teratoon = user.tera_toons.build(name: "Foobar") }

	subject { @teratoon }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @teratoon.user_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				TeraToon.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

end
