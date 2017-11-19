class UserDecorator < Draper::Decorator

  delegate_all

  def streak
    monday_activities = object.monday_activities.select(:start_time)

    streak_count = 0
    streak_broken = false
    beginning_of_streak_week = 1.week.ago
    end_of_streak_week = Time.current

    until streak_broken
      if monday_activities.where(start_time: beginning_of_streak_week..end_of_streak_week).any?
        streak_count += 1
        beginning_of_streak_week -= 1.week
        end_of_streak_week -= 1.week
      else
        streak_broken = true
      end
    end

    streak_count
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
