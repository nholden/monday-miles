require 'rails_helper'

RSpec.describe UserDecorator do

  Given(:decorator) { user.decorate }

  describe "#recent_monday_streak_title" do
    Given(:user) { FactoryGirl.create(:user) }
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

  describe "#location" do
    Given(:user) { User.new }
    When(:result) { decorator.location }

    context "when user has a state" do
      Given { user.city = 'San Diego' }
      Given { user.state = 'California' }
      Given { user.country = 'United States' }

      Then { result == 'San Diego, California' }
    end

    context "when user does not have a state" do
      Given { user.city = 'London' }
      Given { user.state = '' }
      Given { user.country = 'United Kingdom' }

      Then { result == 'London, United Kingdom' }
    end

    context "when user's city matches country" do
      Given { user.city = 'Singapore' }
      Given { user.state = '' }
      Given { user.country = 'Singapore' }

      Then { result == 'Singapore' }
    end
  end

end
