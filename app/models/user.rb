# frozen_string_literal: true

class User < ApplicationRecord

  STALE_AFTER_TIME = 2.months

  has_many :activities
  has_many :monday_activities, -> { monday }, class_name: 'Activity'

  scope :not_archived, -> { where(archived_at: nil) }
  scope :stale, -> { where("last_signed_in_at < ?", STALE_AFTER_TIME.ago) }

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
      user.slug ||= UserSlugGenerator.new(
                      first_name: strava_athlete.first_name,
                      last_name: strava_athlete.last_name
                    ).generate
    end
  end

  def refresh_strava_access_token!
    if strava_access_token_expires_at.nil? || strava_access_token_expires_at < 1.hour.from_now
      access_token = Strava::API.refresh_access_token(refresh_token: strava_refresh_token)

      update!(
        strava_access_token: access_token.access_token,
        strava_access_token_expires_at: access_token.expires_at,
        strava_refresh_token: access_token.refresh_token
      )
    end

    strava_access_token
  end

  def recent_monday_streak
    monday_streaks.recent
  end

  def archived?
    archived_at.present?
  end

  private

  def monday_streaks
    MondayStreaks.new(monday_activities.not_deleted.select(:start_time, :utc_offset).map(&:local_start_date))
  end

end
