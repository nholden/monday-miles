module Strava
  class SessionsController < ApplicationController

    def create
      if auth_response.authenticated?
        if existing_user = User.find_by_strava_id(auth_response.athlete.id)
          existing_user.strava_access_token = auth_response.access_token
          existing_user.last_signed_in_at = Time.current
          existing_user.save!
          StravaActivityWorker.perform_async(existing_user.id, existing_user.last_signed_in_at.try(:iso8601), Time.current.iso8601)
          session[:current_user_id] = existing_user.id
          redirect_to user_profile_path(existing_user.slug)
        else
          new_user = UserCreator.create_from_strava_athlete!(auth_response.athlete, access_token: auth_response.access_token)
          session[:current_user_id] = new_user.id
          StravaActivityWorker.perform_async(new_user.id, nil, Time.current.iso8601)
          redirect_to page_path('loading')
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
