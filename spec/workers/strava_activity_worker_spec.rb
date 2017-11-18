require 'rails_helper'

RSpec.describe StravaActivityWorker do

  around { |example| travel_to(Time.new(2017, 10, 14), &example) }

  Given(:worker) { StravaActivityWorker.new }

  describe "#perform" do
    Given(:user) { FactoryGirl.create(:user, strava_access_token: '00accesstoken00') }
    Given(:user_activities) { user.activities }

    When { worker.perform(user.id, start_time.iso8601, end_time.iso8601) }

    context "when setting the time window the last week" do
      around { |example| VCR.use_cassette('strava_athlete_activities_week', &example) }

      Given(:start_time) { 1.week.ago }
      Given(:end_time) { Time.current }

      context "when none of the activities already exist in the database" do
        Then { user_activities.count == 5 }
        And { user_activities.where('start_time < ?', start_time).none? }
        And { user_activities.where('start_time > ?', end_time).none? }
      end

      context "when one of the activities already exists in the database" do
        Given { FactoryGirl.create(:activity, user: user, strava_id: 1228328056) }
        Then { user_activities.count == 5 }
      end
    end

    context "when setting the time window for a previous fortnight" do
      around { |example| VCR.use_cassette('strava_athlete_activities_fortnight', &example) }

      Given(:start_time) { 3.weeks.ago }
      Given(:end_time) { 1.week.ago }

      Then { user_activities.count == 9 }
      And { user_activities.where('start_time < ?', start_time).none? }
      And { user_activities.where('start_time > ?', end_time).none? }
    end
  end

end
