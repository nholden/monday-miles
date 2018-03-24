class StravaActivitiesInTimeRangeWorker

  include Sidekiq::Worker

  def perform(user_id, start_time_string, end_time_string)
    user = User.find(user_id)
    athlete = Strava::Athlete.from_user(user)
    start_time = start_time_string.present? ? Time.parse(start_time_string) : nil

    athlete.activities(start_time: start_time, end_time: Time.parse(end_time_string)).map do |strava_activity|
      if strava_activity.monday?
        Activity.from_strava_activity(strava_activity, user: user).save!
      end
    end
  end

end
