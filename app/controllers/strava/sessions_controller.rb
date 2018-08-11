module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        user = User.from_strava_athlete(auth_response.athlete)
        user.strava_access_token = auth_response.access_token
        user.last_signed_in_at = Time.current

        if user.new_record? || user.archived?
          user.archived_at = nil
          user.save!
          StravaActivitiesInTimeRangeWorker.perform_async(user.id, nil, Time.current.iso8601)
          session[:current_user_id] = user.id
          redirect_to page_path('loading')
        else
          user.save!
          session[:current_user_id] = user.id
          redirect_to user_profile_path(user.slug)
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
