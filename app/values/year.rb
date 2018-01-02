class Year < Struct.new(:year)

  def mondays_data
    mondays.map do |monday|
      {
        year: monday.year,
        month: monday.month,
        day: monday.day,
        display: I18n.l(monday),
      }
    end
  end

  private

  def mondays
    days.select(&:monday?)
  end

  def days
    Date.new(year)...Date.new(year + 1)
  end

end
