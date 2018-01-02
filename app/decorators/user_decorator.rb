class UserDecorator < Draper::Decorator

  delegate_all

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def location
    "#{object.city}, #{object.state}"
  end

  def recent_monday_streak_title
    object.recent_monday_streak_current? ? "Streak" : "Last Streak"
  end

  def recent_monday_streak_dates_string
    return nil if object.recent_monday_streak_length == 0
    "#{h.l(object.recent_monday_streak_started)} to #{h.l(object.recent_monday_streak_ended)}"
  end

  def monday_activities_year_options_json
    object.monday_activities.pluck(:start_time).map(&:year).uniq.to_json
  end

end
