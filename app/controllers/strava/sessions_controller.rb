module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        user = UserCreator.find_or_create_from_strava_athlete!(auth_response.athlete)
        user.strava_access_token = auth_response.access_token
        user.save! if user.changed?
        flash[:success] = "Hi, #{user.first_name}!"
      else
        flash[:error] = 'Access denied'
      end

      redirect_to new_session_path
    end

    private

    def auth_response
      AuthResponse.new(request.env['omniauth.auth'])
    end

  end
end
