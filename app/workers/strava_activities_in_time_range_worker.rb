class StravaActivitiesInTimeRangeWorker

  include Sidekiq::Worker

  def perform(user_id, start_time_string, end_time_string)
    user = User.find(user_id)
    athlete = Strava::Athlete.from_user(user)
    start_time = start_time_string.present? ? Time.parse(start_time_string) : nil

    athlete.activities(start_time: start_time, end_time: Time.parse(end_time_string)).map do |strava_activity|
      if Activity.where(strava_id: strava_activity.id).any?
        logger.info "[StravaActivitiesInTimeRangeWorker] Skipping Strava activity #{strava_activity.id}, which already exists as an Activity"
      else
        ActivityCreator.create_from_strava_activity!(strava_activity, user: user)
      end
    end
  end

end
