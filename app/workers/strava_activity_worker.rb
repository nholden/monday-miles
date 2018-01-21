class StravaActivityWorker

  include Sidekiq::Worker

  def perform(strava_athlete_id, strava_activity_id)
    user = User.find_by_strava_id!(strava_athlete_id)

    strava_activity = Strava::Activity.fetch(
      strava_activity_id: strava_activity_id,
      access_token: user.strava_access_token
    )

    if strava_activity.deleted?
      logger.info "[StravaActivityWorker] Strava activity with ID #{strava_activity_id} not found. Not creating or updating Activity record."
    else
      Activity.from_strava_activity(strava_activity, user: user).save!
    end
  end

end
