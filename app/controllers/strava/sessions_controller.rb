module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        user = User.from_strava_athlete(auth_response.athlete)
        user.strava_access_token = auth_response.access_token
        redirect_path = user.new_record? ? page_path('loading') : user_profile_path(user.slug)
        user.save! if user.changed?
        StravaActivityWorker.perform_async(user.id, user.last_signed_in_at.try(:iso8601), Time.current.iso8601)
        user.update! last_signed_in_at: Time.current
        session[:current_user_id] = user.id
        redirect_to redirect_path
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
