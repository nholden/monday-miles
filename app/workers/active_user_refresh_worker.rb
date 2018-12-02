# frozen_string_literal: true

class ActiveUserRefreshWorker

  include Sidekiq::Worker

  def perform
    User.not_archived.find_each do |user|
      begin
        user.refresh_strava_access_token!
        start_time_string = user.last_signed_in_at.try(:iso8601)
        logger.info "[ActiveUserRefreshWorker] Fetching activities for User #{user.id} since #{start_time_string.presence || 'the beginning' }."
        StravaActivitiesInTimeRangeWorker.perform_async(user.id, start_time_string, Time.current.iso8601)
      rescue Strava::API::UnauthorizedError => ex
        logger.info "[ActiveUserRefreshWorker] Rescued Strava::API::UnauthorizedError: #{ex.message}. Did the user revoke access?"
        user.update! archived_at: Time.current
        user.activities.delete_all
      end
    end
  end

end
