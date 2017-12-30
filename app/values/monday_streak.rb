class MondayStreak

  def initialize(dates:, before:)
    @mondays = dates.select(&:monday?).uniq
    @before = before
  end

  def length
    consecutive_mondays.count
  end

  def started
    consecutive_mondays.first
  end

  def ended
    consecutive_mondays.last
  end

  private

  def consecutive_mondays
    @consecutive_mondays ||= [].tap do |result|
      remaining_mondays = @mondays.sort.select { |monday| monday <= @before }
      streak_continuing_monday = remaining_mondays.last

      while remaining_mondays.any? && remaining_mondays.last == streak_continuing_monday
        result.unshift remaining_mondays.pop
        streak_continuing_monday -= 1.week
      end
    end
  end

end
