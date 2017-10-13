module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        user = UserCreator.find_or_create_from_strava_athlete!(auth_response.athlete)
        user.strava_access_token = auth_response.access_token
        user.save! if user.changed?
        session[:current_user_id] = user.id
      else
        flash[:error] = 'Access denied'
      end

      redirect_to root_path
    end

    private

    def auth_response
      AuthResponse.new(request.env['omniauth.auth'])
    end

  end
end
