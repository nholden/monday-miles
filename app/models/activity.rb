# frozen_string_literal: true

class Activity < ApplicationRecord

  belongs_to :user

  scope :monday, -> { where(monday: true).order(start_time: :desc) }
  scope :in_year, -> (year) { where(start_time: Date.new(year)...Date.new(year + 1)) }
  scope :not_deleted, -> { where(deleted_at: nil) }

  def self.from_strava_activity(strava_activity, user:)
    (find_by_strava_id(strava_activity.id) || new).tap do |activity|
      activity.strava_id = strava_activity.id
      activity.user = user
      activity.name = strava_activity.name
      activity.distance = strava_activity.distance
      activity.moving_time = strava_activity.moving_time
      activity.elapsed_time = strava_activity.elapsed_time
      activity.total_elevation_gain = strava_activity.total_elevation_gain
      activity.activity_type = strava_activity.type
      activity.start_time = strava_activity.start_time
      activity.utc_offset = strava_activity.utc_offset
      activity.start_lat = strava_activity.start_lat
      activity.start_lng = strava_activity.start_lng
      activity.city = strava_activity.city
      activity.state = strava_activity.state
      activity.country = strava_activity.country
      activity.polyline = strava_activity.polyline
      activity.elev_high = strava_activity.elev_high
      activity.elev_low = strava_activity.elev_low
      activity.average_temp = strava_activity.average_temp
      activity.monday = strava_activity.monday?
    end
  end

  def local_start_date
    (start_time + utc_offset.minutes).to_date
  end

end
