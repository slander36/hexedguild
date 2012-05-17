class WowToonsController < ApplicationController

	before_filter :signed_in_user

	def create
		@toon = current_user.wow_toons.build(params[:wow_toon])
		if @toon.save
			flash[:success] = "Character Added"
		else
			flash[:error] = "Error Adding Character"
		end
		redirect_to current_user
	end

	def destroy
		@toon = WowToon.find(params[:id])
		if @toon.user == current_user
			if @toon.destroy
				flash[:success] = "Character Deleted"
			else
				flash[:error] = "Character Failed to be Deleted"
			end
		else
			flash[:error] = "You Do Not Have Access to That Action"
		end
		redirect_to current_user
	end

end
