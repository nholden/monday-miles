require 'rails_helper'

RSpec.describe MondayStreak do

  around { |example| travel_to(Time.iso8601('2017-12-29T00:00:00-07:00'), &example) }

  Given(:monday_streak) { MondayStreak.new(dates) }
  Given(:last_monday) { Date.current.beginning_of_week(:monday) }
  Given(:two_mondays_ago) { last_monday - 1.week }
  Given(:three_mondays_ago) { last_monday - 2.weeks }
  Given(:five_mondays_ago) { last_monday - 4.weeks }

  describe "#current_length" do
    When(:result) { monday_streak.current_length }

    context "when there is a current streak" do
      Given(:dates) { [last_monday, two_mondays_ago, three_mondays_ago, five_mondays_ago] }
      Then { result == 3 }
    end

    context "when there is not a current streak" do
      Given(:dates) { [two_mondays_ago, three_mondays_ago, five_mondays_ago] }
      Then { result == 0 }
    end
  end

end
