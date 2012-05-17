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

class TeraToon < ActiveRecord::Base
  attr_accessible :name
	belongs_to :user

	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :user_id, presence: true
end
