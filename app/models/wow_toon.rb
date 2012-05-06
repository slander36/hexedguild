class WowToon < ActiveRecord::Base
  attr_accessible :name
	belongs_to :user

	validates :user_id, presence: true

	default_scope order: 'wow_toons.created_at DESC'
end
