class ArticlesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]
	before_filter :correct_user, only: [:destroy]
	before_filter :member_user, only: [:create, :destroy]

	def index
	end

	def create
		@article = current_user.articles.build(params[:article])
		if @article.save
			flash[:success] = "Article posted"
			if @article.wow and !@article.tera
				redirect_to wow_path
			end
			if @article.tera and !@article.wow
				redirect_to tera_path
			end
			if @article.tera and @article.wow
				redirect_to root_path
			end
		else
			@announcement = Article.where(announcement: true).limit(1)
			@articles = Article.where(announcement: false).limit(10)
			flash.now[:error] = "Error creating article"
			render 'static_pages/home'
		end
	end

	def destroy
		@article.destroy
		redirect_back_or root_path
	end

	private
		
		def correct_user
			if !current_user.admin
				@article = current_user.articles.find_by_id(params[:id])
			else
				@article = Article.find_by_id(params[:id])
			end
			redirect_to root_path if @article.nil?
		end

end
