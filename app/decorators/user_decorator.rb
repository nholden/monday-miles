class UserDecorator < Draper::Decorator

  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def location
    "#{object.city}, #{object.state}"
  end

  def recent_monday_streak_dates_string
    return nil if object.recent_monday_streak_length == 0
    "#{h.l(object.recent_monday_streak_started)} to #{h.l(object.recent_monday_streak_ended)}"
  end

  def ytd_monday_miles
    h.number_with_precision(
      Meters.new(object.ytd_monday_activities.pluck(:distance).reduce(&:+)).to_miles,
      precision: 1,
      delimiter: ','
    )
  end

  def ytd_monday_feet_elevation_gain
    h.number_with_precision(
      Meters.new(object.ytd_monday_activities.pluck(:total_elevation_gain).reduce(&:+)).to_feet,
      precision: 0,
      delimiter: ','
    )
  end

  def ytd_monday_hours
    h.number_with_precision(
      Seconds.new(object.ytd_monday_activities.pluck(:moving_time).reduce(&:+)).to_hours,
      precision: 1,
      delimiter: ','
    )
  end

end
