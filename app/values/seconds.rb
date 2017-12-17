class Seconds < Unit

  def to_hours
    quantity / 3_600.0
  end

  def to_duration
    sign = quantity < 0 ? '-' : ''
    hours = quantity.abs / 3_600
    minutes = (quantity.abs % 3_600) / 60
    minutes_with_leading_zero = minutes.to_s.rjust(2, '0')
    seconds = (quantity.abs % 60).to_s.rjust(2, '0')

    if hours > 0
      "#{sign}#{hours}:#{minutes_with_leading_zero}:#{seconds}"
    else
      "#{sign}#{minutes}:#{seconds}"
    end
  end

end
