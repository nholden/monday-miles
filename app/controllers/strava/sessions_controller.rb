module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        if existing_user = User.find_by_strava_id(auth_response.athlete.id)
          existing_user.strava_access_token = auth_response.access_token
          existing_user.save! if existing_user.changed?
          session[:current_user_id] = existing_user.id
          redirect_to root_path
        else
          new_user = UserCreator.create_from_strava_athlete!(auth_response.athlete, access_token: auth_response.access_token)
          session[:current_user_id] = new_user.id
          redirect_to '/loading'
        end
      else
        flash[:error] = 'Access denied'
        redirect_to root_path
      end
    end

    private

    def auth_response
      AuthResponse.new(request.env['omniauth.auth'])
    end

  end
end
