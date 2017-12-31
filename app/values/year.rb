class Year < Struct.new(:year)

  def mondays_by_month
    Date::ABBR_MONTHNAMES.map.with_index do |name, index|
      {
        name: name,
        mondays: mondays.select { |monday| monday.month == index }.map(&:day)
      }
    end.last(12)
  end

  private

  def mondays
    days.select(&:monday?)
  end

  def days
    Date.new(year)..Date.new(year + 1)
  end

end
