require 'rails_helper'

RSpec.describe UserDecorator do

  Given(:user) { FactoryGirl.create(:user) }
  Given(:decorator) { user.decorate }

  describe "#recent_monday_streak_title" do
    When(:result) { decorator.recent_monday_streak_title }

    context "when streak is ongoing" do
      Given { FactoryGirl.create(:activity, :last_monday, user: user) }
      Then { result == 'Streak' }
    end

    context "when streak has ended" do
      Given { FactoryGirl.create(:activity, :two_mondays_ago, user: user) }
      Then { result == 'Last Streak' }
    end
  end

end
