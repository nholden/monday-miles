class DeletedStravaActivityWorker

  include Sidekiq::Worker

  def perform(strava_athlete_id, strava_activity_id)
    user = User.find_by_strava_id!(strava_athlete_id)

    strava_activity = Strava::Activity.fetch(
      strava_activity_id: strava_activity_id,
      access_token: user.strava_access_token
    )

    if strava_activity.deleted?
      Activity.find_by_strava_id!(strava_activity_id).update! deleted_at: Time.current
    else
      raise 'Tried to delete non-deleted Strava activity'
    end
  end

end
