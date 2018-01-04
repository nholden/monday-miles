class Year < Struct.new(:year)

  def mondays_data(on_or_before_date:)
    mondays.
      select { |monday| monday <= on_or_before_date }.
      map do |monday|
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
