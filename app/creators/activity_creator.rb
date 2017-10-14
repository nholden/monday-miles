class ActivityCreator

  DuplicateActivityError = Class.new(StandardError)

  def self.create_from_strava_activity!(strava_activity, user:)
    if Activity.find_by_strava_id(strava_activity.id)
      raise DuplicateActivityError
    else
      user.activities.create!(
        strava_id: strava_activity.id,
        name: strava_activity.name,
        distance: strava_activity.distance,
        moving_time: strava_activity.moving_time,
        elapsed_time: strava_activity.elapsed_time,
        total_elevation_gain: strava_activity.total_elevation_gain,
        activity_type: strava_activity.type,
        start_time: strava_activity.start_time,
        utc_offset: strava_activity.utc_offset,
        start_lat: strava_activity.start_lat,
        start_lng: strava_activity.start_lng,
        city: strava_activity.city,
        state: strava_activity.state,
        country: strava_activity.country,
        polyline: strava_activity.polyline,
        elev_high: strava_activity.elev_high,
        elev_low: strava_activity.elev_low,
        average_temp: strava_activity.average_temp
      )
    end
  end

end
