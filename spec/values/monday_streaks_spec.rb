require 'rails_helper'

RSpec.describe MondayStreaks do

  around { |example| travel_to(Time.iso8601('2017-12-29T00:00:00-07:00'), &example) }

  Given(:monday_streaks) { MondayStreaks.new(dates) }
  Given(:last_monday) { Date.current.beginning_of_week(:monday) }
  Given(:two_mondays_ago) { last_monday - 1.week }
  Given(:three_mondays_ago) { last_monday - 2.weeks }
  Given(:five_mondays_ago) { last_monday - 4.weeks }

  describe "#recent" do
    When(:result) { monday_streaks.recent }

    context "when the most recent streak began last monday" do
      Given(:dates) { [last_monday, two_mondays_ago, three_mondays_ago, five_mondays_ago] }

      Then { result.length == 3 }
      And { result.started == three_mondays_ago }
      And { result.ended == last_monday }
    end

    context "when the most recent streak began before last monday" do
      Given(:dates) { [two_mondays_ago, three_mondays_ago, five_mondays_ago] }

      Then { result.length == 2 }
      And { result.started == three_mondays_ago }
      And { result.ended == two_mondays_ago }
    end
  end

end
