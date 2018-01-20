module Strava
  class WebhookCallbacksController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      event = Strava::WebhookEvent.new(params)

      if event.created_or_updated_activity?
        StravaActivityWorker.perform_async(event.strava_athlete_id, event.strava_activity_id)
      end

      render plain: 'success', status: 200
    end

    def show
      if challenge = params['hub.challenge'].presence
        render json: { 'hub.challenge' => challenge }, status: 200
      else
        raise "Expected request to be subscription response, missing 'hub.challenge' key"
      end
    end

  end
end
