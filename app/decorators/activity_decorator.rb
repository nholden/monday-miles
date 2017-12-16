class ActivityDecorator < Draper::Decorator

  delegate_all

  def vue_data
    {
      id: object.id,
      stravaUrl: strava_url,
      name: object.name,
      map: map,
      date: date,
      miles: miles,
      feetElev: feet_elevation_gain,
      hours: hours,
    }
  end

  private
  
  def strava_url
    "https://www.strava.com/activities/#{object.strava_id}"
  end


  def map
    h.image_tag(
      [
        "https://maps.googleapis.com/maps/api/staticmap?size=640x300",
        "path=weight:3%7Ccolor:0xE83A30%7Cenc:#{object.polyline}",
        "key=#{ENV.fetch('GOOGLE_API_KEY')}"
      ].join('&'),
      width: '100%',
      height: 'auto',
      alt: "Map of #{activity.name}"
    )
  end

  def date
    object.start_time.strftime('%b. %e, %Y')
  end

  def miles
    h.number_with_precision(
      Meters.new(object.distance).to_miles,
      precision: 1,
      delimiter: ','
    )
  end

  def feet_elevation_gain
    h.number_with_precision(
      Meters.new(object.total_elevation_gain).to_feet,
      precision: 0,
      delimiter: ','
    )
  end

  def hours
    h.number_with_precision(
      Seconds.new(object.moving_time).to_hours,
      precision: 1,
      delimiter: ','
    )
  end

end
