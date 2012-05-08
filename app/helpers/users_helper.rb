module UsersHelper

	def user_game(user)
		if (user.wow and user.tera) or (not user.wow and not user.tera)
			"combined"
		else
			if user.wow
				"wow"
			else
				"tera"
			end
		end
	end
end
