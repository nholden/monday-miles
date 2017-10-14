class StravaActivityWorker

  include Sidekiq::Worker

  def perform(user_id, start_time_string, end_time_string)
    user = User.find(user_id)
    athlete = Strava::Athlete.from_user(user)
    athlete.activities(Time.parse(start_time_string), Time.parse(end_time_string)).map do |strava_activity|
      ActivityCreator.create_from_strava_activity!(strava_activity, user: user)
    end
  end

end
