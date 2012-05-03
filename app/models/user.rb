# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  character  :string(255)
#  email      :string(255)
#  tera       :boolean
#  wow        :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :character, :email, :name, :tera, :wow, :password, :password_confirmation
	has_secure_password

	before_save { |user| user.email = email.downcase }

	validates :name,
		presence: true,
		length: { maximum: 50 }
	
	validates :character,
		presence: true,
		length: { maximum: 16 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :email,
		presence: true,
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }

	validates :password,
		presence: true,
		length: { minimum: 6 }
	
	validates :password_confirmation,
		presence: true
end
