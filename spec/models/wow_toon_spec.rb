require 'spec_helper'

describe WowToon do
	
	let(:user) { FactoryGirl.create(:user) }
	before do
		@wowtoon = user.wow_toons.build(name: "Foobar")
	end

	subject { @wowtoon }

	it { should respond_to(:name) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should == user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @wowtoon.user_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				WowToon.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
end
