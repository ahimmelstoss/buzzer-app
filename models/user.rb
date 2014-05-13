class User < ActiveRecord::Base

	def password?(login_password)
		login_password == password
	end

  def admin?
    username == "Amanda" || username == "Alex"
  end
  
end
