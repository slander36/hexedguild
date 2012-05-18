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

class User < ActiveRecord::Base
  attr_accessible :character, :email, :name, :tera, :wow, :apply, :password, :password_confirmation
	has_secure_password

	has_many :wow_toons, dependent: :destroy
	has_many :tera_toons, dependent: :destroy
	has_many :articles

	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token

	validates :name,
		presence: true,
		length: { maximum: 50 }
		
	
	validates :character,
		presence: true,
		length: { maximum: 16 },
		exclusion: { in: %w( admin signin signup user users apply about contact members forum tera wow home signout) }
	
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

	validates :apply, presence: true, length: { maximum: 500 }

	validates :wow, presence: { unless: "tera", message: "Must be part of WoW or TERA" }

	private
		
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
