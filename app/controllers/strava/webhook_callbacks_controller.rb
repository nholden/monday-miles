module Strava
  class WebhookCallbacksController < ApplicationController

    skip_before_action :verify_authenticity_token

    def create
      render plain: 'success', status: 200
    end

  end
end
