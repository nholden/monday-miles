# frozen_string_literal: true

class MondayStreaks < Struct.new(:dates)

  def recent
    MondayStreak.new(dates: dates, before: Date.current)
  end

end
