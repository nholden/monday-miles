# frozen_string_literal: true

module Strava
  class AthleteActivities

    MAX_ACTIVITIES_PER_API_CALL = 200

    MissingAccessTokenError = Class.new(StandardError)

    def initialize(access_token:, start_time:, end_time:)
      raise MissingAccessTokenError unless access_token.present?

      @access_token = access_token
      @start_time = start_time
      @end_time = end_time
    end

    def activities
      page = 1
      all_pages_fetched = false
      activity_data = []

      until all_pages_fetched
        page_activity_data = activity_data_for_page(page)
        activity_data += page_activity_data
        page += 1
        all_pages_fetched = page_activity_data.count != MAX_ACTIVITIES_PER_API_CALL
      end

      activity_data.map { |data| Strava::Activity.new(data) }
    end

    private

    def activity_data_for_page(page)
      API.get(path: 'athlete/activities',
              access_token: @access_token,
              query: { after: @start_time.to_i, before: @end_time.to_i, per_page: MAX_ACTIVITIES_PER_API_CALL, page: page })
    rescue API::UnauthorizedError => ex
      Rails.logger.info "[Strava::AthleteActivities] Rescued Strava::API::UnauthorizedError: #{ex.message}. Did the user revoke access?"
      []
    end

  end
end
