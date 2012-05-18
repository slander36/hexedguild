class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :show, :destroy, :admin]  
	before_filter :correct_user, only: [:edit, :update]
	before_filter :member_user, only: :show
	before_filter :admin_user, only: :destroy

	def new
		@user = User.new
  end

	def create
		@user = User.new(params[:user])
		if @user.save
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
		@user = get_user(params)
		if @user.nil?
			flash[:notice] = "User not found"
			redirect_to root_path
		else
			@wow_toon = current_user.wow_toons.build if signed_in?
			@wow_toons = @user.wow_toons
			@tera_toon = current_user.tera_toons.build if signed_in?
			@tera_toons = @user.tera_toons
			@articles = @user.articles.paginate(page: params[:page], per_page: 20)
		end
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
		if @user == current_user
			@relog = true
		end
		if @user.toggle!(:member)
			flash[:success] = "#{@user.character} Confirmed!"
		else
			flash[:error] = "Error Confirming #{@user.character}"
		end
		if @relog
			sign_out
			sign_in @user
		end
		redirect_to members_path
	end

	def admin
	end

	def admin_login
		if params[:password] == "1337guildm45732"
			@user = current_user
			if not @user.admin and @user.toggle!(:admin)
				sign_out
				sign_in @user
				flash[:success] = "This account is now an admin account"
				redirect_to @user
			else
				if @user.admin
					flash[:error] = "User is already an admin"
					redirect_to @user
				else
					flash[:error] = "Error logging in as an admin"
					redirect_to root_path
				end
			end
		else
			flash[:error] = "Invalid attempt at access. Your account will be reported."
			# add a report function at some point
			redirect_to root_path
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to members_path
	end
end
