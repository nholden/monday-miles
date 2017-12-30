class MondayStreak

  def initialize(dates)
    @mondays = dates.select(&:monday?)
  end

  def current_length
    consecutive_mondays(before: Date.current).count
  end

  private

  def consecutive_mondays(before:)
    remaining_mondays = @mondays.sort.select { |monday| monday <= before }
    streak_continuing_monday = before.beginning_of_week(:monday)

    [].tap do |result|
      while remaining_mondays.last == streak_continuing_monday
        result << remaining_mondays.pop
        streak_continuing_monday -= 1.week
      end
    end
  end

end
