class TeraToon < ActiveRecord::Base
  attr_accessible :name
	belongs_to :user

	validates :user_id, presence: true
end
