class ActivitiesDecorator < Draper::CollectionDecorator

  def vue_data
    {
      summary: {
        miles: miles,
        feetElev: feet_elevation_gain,
        hours: hours,
        activityCount: object.count,
      },
      activities: map(&:vue_data),
    }
  end

  private

  def miles
    h.number_with_precision(
      Meters.new(object.pluck(:distance).reduce(&:+)).to_miles,
      precision: 1,
      delimiter: ','
    )
  end

  def feet_elevation_gain
    h.number_with_precision(
      Meters.new(object.pluck(:total_elevation_gain).reduce(&:+)).to_feet,
      precision: 0,
      delimiter: ','
    )
  end

  def hours
    h.number_with_precision(
      Seconds.new(object.pluck(:moving_time).reduce(&:+)).to_hours,
      precision: 1,
      delimiter: ','
    )
  end

end
