class NewStravaActivityWorker

  include Sidekiq::Worker

  def perform(strava_athlete_id, strava_activity_id)
    user = User.find_by_strava_id!(strava_athlete_id)

    strava_activity = Strava::Activity.fetch(
      strava_activity_id: strava_activity_id,
      access_token: user.strava_access_token
    )

    ActivityCreator.create_from_strava_activity!(strava_activity, user: user)
  end

end
