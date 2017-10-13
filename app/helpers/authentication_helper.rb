module AuthenticationHelper

  def current_user
    User.find(session[:current_user_id]) if session[:current_user_id]
  end

  def authenticated?
    current_user.present?
  end

end
