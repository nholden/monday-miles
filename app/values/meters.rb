# frozen_string_literal: true

class Meters < Unit

  def to_miles
    quantity * 0.000621371
  end

  def to_feet
    quantity * 3.28084
  end

end
