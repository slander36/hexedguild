class StaticPagesController < ApplicationController
  def home
		@article = current_user.articles.build if signed_in?
		@announcement = Article.where(announcement: true).limit(1)
		@articles = Article.where(announcement: false).limit(10)
  end

	def wow
		@announcement = Article.where(announcement: true).where(wow: true).limit(1)
		@articles = Article.where(announcement: false).where(wow: true).paginate(page: params[:page])
	end

	def tera
		@announcement = Article.where(announcement: true).where(tera: true).limit(1)
		@articles = Article.where(announcement: false).where(tera: true).paginate(page: params[:page])
	end

  def help
  end

  def contact
  end

	def about
	end

	def admin
	end
end
