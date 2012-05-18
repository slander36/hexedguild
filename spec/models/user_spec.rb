# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  character       :string(255)
#  email           :string(255)
#  tera            :boolean
#  wow             :boolean
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  member          :boolean         default(FALSE)
#  admin           :boolean         default(FALSE)
#  apply           :string(255)
#

require 'spec_helper'

describe User do
  
	before { @user = User.new(name: "Example User",
		character: "Foobar",
		email: "user@example.com",
		tera: true,
		wow: true,
		apply: "Application",
		password: "foobar",
		password_confirmation: "foobar") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:character) }
	it { should respond_to(:email) }
	it { should respond_to(:tera) }
	it { should respond_to(:wow) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }

	it { should respond_to(:member) }
	it { should respond_to(:admin) }

	it { should respond_to(:wow_toons) }
	it { should respond_to(:tera_toons) }

	it { should respond_to(:articles) }

	it { should be_valid }
	it { should_not be_member }
	it { should_not be_admin }

	describe "with member attribute set to 'true'" do
		before { @user.toggle!(:member) }
		it { should be_member }
	end

	describe "with admin attribute set to 'true'" do
		before { @user.toggle!(:admin) }
		it { should be_admin }
	end

	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a"*51 }
		it { should_not be_valid }
	end

	describe "when character is not present" do
		before { @user.character = " " }
		it { should_not be_valid }
	end

	describe "when character is too long" do
		before { @user.character = "a"*17 }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when email format is not valid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.com A_USER@f.b.org frst.lst@goo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a"*5 }
		it { should_not be_valid }
	end

	describe "return value of authentication method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

	describe "wow_toon associations" do
		before { @user.save }
		let!(:older_wow_toon) do
			FactoryGirl.create(:wow_toon,
				user: @user,
				name: "Toon1",
				created_at: 1.day.ago)
		end
		let!(:newer_wow_toon) do
			FactoryGirl.create(:wow_toon,
				user: @user,
				name: "Toon2",
				created_at: 1.hour.ago)
		end

		it "should have the right toons in the right order" do
			@user.wow_toons.should == [newer_wow_toon, older_wow_toon]
		end

		it "should destroy associated wow_toons" do
			wow_toons = @user.wow_toons
			@user.destroy
			wow_toons.each do |wow_toon|
				WowToon.find_by_id(wow_toon.id).should be_nil
			end
		end
	end

	describe "tera_toon associations" do
		before { @user.save }
		let!(:older_tera_toon) do
			FactoryGirl.create(:tera_toon,
				name: "Toon1",
				user: @user,
				created_at: 1.day.ago)
		end
		let!(:newer_tera_toon) do
			FactoryGirl.create(:tera_toon,
				name: "Toon2",
				user: @user,
				created_at: 1.hour.ago)
		end

		it "should ahve the right toons in the right order" do
			@user.tera_toons.should == [newer_tera_toon, older_tera_toon]
		end

		it "should destroy associated tera_toons" do
			tera_toons = @user.tera_toons
			@user.destroy
			tera_toons.each do |tera_toon|
				TeraToon.find_by_id(tera_toon.id).should be_nil
			end
		end
	end

	describe "article association" do
		before { @user.save }
		let!(:older_article) do
			FactoryGirl.create(:article, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_article) do
			FactoryGirl.create(:article, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right articles in the right order" do
			@user.articles.should == [newer_article, older_article]
		end
	end
end
