class SessionError < RuntimeError

  def self.check_session_admin(session)
    if !session[:admin_username]
      raise SessionError
    end
  end

  def self.check_session_guest_or_admin(session)
    if !session[:guest_username] && !session[:admin_username]
      raise SessionError
    end
  end

end