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

  def monday_activities_year_options_json
    object.monday_activities.pluck(:start_time).map(&:year).uniq.to_json
  end

  def ytd_monday_miles
    monday_miles_in_year(Time.current.year)
  end

  def ytd_monday_feet_elevation_gain
    monday_feet_elevation_gain_in_year(Time.current.year)
  end

  def ytd_monday_hours
    monday_hours_in_year(Time.current.year)
  end

  def ytd_monday_activities_count
    monday_activities_count_in_year(Time.current.year)
  end

  def monday_miles_in_year(year)
    h.number_with_precision(
      Meters.new(object.monday_activities.in_year(year).pluck(:distance).reduce(&:+)).to_miles,
      precision: 1,
      delimiter: ','
    )
  end

  def monday_feet_elevation_gain_in_year(year)
    h.number_with_precision(
      Meters.new(object.monday_activities.in_year(year).pluck(:total_elevation_gain).reduce(&:+)).to_feet,
      precision: 0,
      delimiter: ','
    )
  end

  def monday_hours_in_year(year)
    h.number_with_precision(
      Seconds.new(object.monday_activities.in_year(year).pluck(:moving_time).reduce(&:+)).to_hours,
      precision: 1,
      delimiter: ','
    )
  end

  def monday_activities_count_in_year(year)
    object.monday_activities.in_year(year).count
  end

end
