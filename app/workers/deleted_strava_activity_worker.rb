# frozen_string_literal: true

class DeletedStravaActivityWorker

  include Sidekiq::Worker

  def perform(strava_athlete_id, strava_activity_id)
    user = User.find_by_strava_id!(strava_athlete_id)

    begin
      strava_activity = Strava::Activity.fetch(
        strava_activity_id: strava_activity_id,
        access_token: user.refresh_strava_access_token!
      )
    rescue Strava::API::ForbiddenError => ex
      Rails.logger.info "[DeletedStravaActivityWorker] Rescued Strava::API::ForbiddenError: #{ex.message}. Archiving user #{user.id}."
      user.archive!
      return
    end

    if strava_activity.deleted?
      if activity = Activity.find_by_strava_id(strava_activity_id)
        activity.update! deleted_at: Time.current
      else
        logger.info "[DeletedStravaActivityWorker] Activity with strava ID #{strava_activity_id} not found. Not deleting Activity record."
      end
    else
      logger.info "[DeletedStravaActivityWorker] Activity with strava ID #{strava_activity_id} not deleted. Not deleting Activity record."
    end
  end

end
