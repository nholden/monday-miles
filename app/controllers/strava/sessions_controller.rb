module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        flash[:success] = "Hi, #{auth_response.first_name}!"
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
