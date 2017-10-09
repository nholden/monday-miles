module Strava
  class SessionsController < ApplicationController

    def create
      if auth_hash['access_token'].present?
        flash[:success] = "Hi, #{auth_hash['athlete']['firstname']}!"
      else
        flash[:error] = 'Access denied'
      end

      redirect_to new_session_path
    end

    private

    def auth_hash
      request.env['omniauth.auth']
    end

  end
end
