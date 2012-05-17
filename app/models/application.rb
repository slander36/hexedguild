# == Schema Information
#
# Table name: applications
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Application < ActiveRecord::Base
  attr_accessible :content, :user_id
end
