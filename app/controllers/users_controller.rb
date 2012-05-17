class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :show, :destroy]  
	before_filter :correct_user, only: [:edit, :update]
	before_filter :member_user, only: :show
	before_filter :admin_user, only: :destroy

	def new
		@user = User.new
  end

	def create
		@user = User.new(params[:user])
		if (@user.wow or @user.tera) and @user.save
			sign_in @user
			flash[:success] = "Welcome to Hexed!"
			redirect_to member_path(@user.character)
		else
			render 'new'
		end
	end

	def index
		@users = User.paginate(page: params[:page])
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
		@wow_toon = current_user.wow_toons.build if signed_in?
		@wow_toons = @user.wow_toons
		@tera_toon = current_user.tera_toons.build if signed_in?
		@tera_toons = @user.tera_toons
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile Updated"
			sign_in @user
			redirect_to member_path(@user.character)
		else
			render 'edit'
		end
	end

	def confirm
		@user = get_user(params)
		if @user.toggle!(:member)
			flash[:success] = "#{@user.character} Confirmed!"
		else
			flash[:error] = "Error Confirming #{@user.character}"
		end
		redirect_to members_path
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to members_path
	end

	private

		def get_user(params)
			if params[:id]
				@user = User.find(params[:id])
			end
			if params[:character]
				@user = User.find_by_character(params[:character])
			end
			@user
		end

		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_path, notice: "Please sign in."
			end			
		end

		def correct_user
			@user = get_user(params)
			redirect_to(root_path) unless current_user?(@user)
		end

		def member_user
			@user = get_user(params)
			unless ( current_user.member? or current_user?(@user) )
				redirect_to(root_path)
			end
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
