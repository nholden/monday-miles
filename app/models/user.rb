class User < ApplicationRecord

  has_many :activities
  has_many :monday_activities, -> { monday }, class_name: 'Activity'

  delegate :length, :started, :ended, :current?,
    to: :recent_monday_streak, prefix: true

  def self.from_strava_athlete(strava_athlete)
    (find_by_strava_id(strava_athlete.id) || new).tap do |user|
      user.strava_id = strava_athlete.id
      user.first_name = strava_athlete.first_name
      user.last_name = strava_athlete.last_name
      user.medium_profile_image_url = strava_athlete.medium_profile_image_url
      user.large_profile_image_url = strava_athlete.large_profile_image_url
      user.city = strava_athlete.city
      user.state = strava_athlete.state
      user.country = strava_athlete.country
      user.gender = strava_athlete.gender
      user.email = strava_athlete.email
      user.slug = UserSlugGenerator.new(
                     first_name: strava_athlete.first_name,
                     last_name: strava_athlete.last_name
                   ).generate
    end
  end

  def recent_monday_streak
    monday_streaks.recent
  end

  private

  def monday_streaks
    MondayStreaks.new(monday_activities.pluck(:start_time).map(&:to_date))
  end

end
