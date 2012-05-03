class UsersController < ApplicationController
  
	def new
		@user = User.new
  end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to Hexed!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def show
		if params[:id]
			@user = User.find(params[:id])
		end
		if params[:character]
			@user = User.find_by_character(params[:character])
		end

		if @user.nil?
			redirect_to root_path
		end
	end
end
