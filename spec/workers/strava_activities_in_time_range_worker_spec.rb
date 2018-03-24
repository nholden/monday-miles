require 'rails_helper'

RSpec.describe StravaActivitiesInTimeRangeWorker do

  around { |example| travel_to(Time.iso8601('2017-10-14T00:00:00-07:00'), &example) }

  Given(:worker) { StravaActivitiesInTimeRangeWorker.new }

  describe "#perform" do
    Given(:user) { FactoryGirl.create(:user, strava_access_token: access_token) }
    Given(:user_activities) { user.activities }

    When { worker.perform(user.id, start_time.iso8601, end_time.iso8601) }

    context "with a valid access token" do
      Given(:access_token) { '00accesstoken00' }

      context "when setting the time window the last week" do
        around { |example| VCR.use_cassette('strava_athlete_activities_week', &example) }

        Given(:start_time) { 1.week.ago }
        Given(:end_time) { Time.current }

        context "when none of the activities already exist in the database" do
          Then { user_activities.count == 1 }
          And { user_activities.where('start_time < ?', start_time).none? }
          And { user_activities.where('start_time > ?', end_time).none? }
          And { user_activities.all?(&:monday?) }
        end

        context "when one of the activities already exists in the database" do
          Given!(:existing_activity) { FactoryGirl.create(:activity,
                                                          user: user,
                                                          strava_id: 1222681008,
                                                          name: 'Old activity name') }

          When { existing_activity.reload }

          Then { user_activities.count == 1 }
          And { existing_activity.name == 'Later start but keeping the Monday morning run streak alive' }
          And { user_activities.all?(&:monday?) }
        end
      end

      context "when setting the time window for a previous fortnight" do
        around { |example| VCR.use_cassette('strava_athlete_activities_fortnight', &example) }

        Given(:start_time) { 3.weeks.ago }
        Given(:end_time) { 1.week.ago }

        Then { user_activities.count == 2 }
        And { user_activities.where('start_time < ?', start_time).none? }
        And { user_activities.where('start_time > ?', end_time).none? }
        And { user_activities.all?(&:monday?) }
      end
    end

    context "with an invalid access token" do
      around { |example| VCR.use_cassette('strava_athlete_activities_invalid_token', &example) }

      Given(:access_token) { 'invalid-token' }
      Given(:start_time) { 1.week.ago }
      Given(:end_time) { Time.current }

      context "when none of the activities already exist in the database" do
        Then { user_activities.count == 0 }
      end
    end
  end

end
