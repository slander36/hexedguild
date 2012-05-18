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

class Article < ActiveRecord::Base
  attr_accessible :announcement,
		:members_only,
		:content,
		:wow,
		:tera,
		:title

	belongs_to :user

	validates :user_id, presence: true
	validates :title, presence: true
	validates :content, length: { maximum: 5000 }
	validates :wow, presence: { unless: "tera", message: "Must be part of WoW or TERA" }

	default_scope order: 	'articles.created_at DESC'
end
