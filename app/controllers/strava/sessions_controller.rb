module Strava
  class SessionsController < ApplicationController

    def create
      raw_response = Excon.post("https://www.strava.com/oauth/token",
        query: {
          client_id: ENV.fetch('STRAVA_CLIENT_ID'),
          client_secret: ENV.fetch('STRAVA_CLIENT_SECRET'),
          code: params[:code],
        }
      )
      auth_response = AuthResponse.new(JSON.parse(raw_response.body))

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

  end
end
