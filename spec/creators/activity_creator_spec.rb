require 'rails_helper'

RSpec.describe ActivityCreator do

  describe ".create_from_strava_activity!" do
    Given(:strava_activity) { Strava::Activity.new(data) }
    Given(:data) { JSON.parse(file_fixture('strava/activity.json').read) }
    Given(:user) { FactoryGirl.create(:user) }

    When(:result) { ActivityCreator.create_from_strava_activity!(strava_activity, user: user) }

    context "when matching activity exists" do
      Given!(:existing_activity) { FactoryGirl.create(:activity, user: user, strava_id: 999582172) }
      Then { expect(result).to have_raised ActivityCreator::DuplicateActivityError }
    end

    context "when matching activity does not exist" do
      context "when activity is on a monday" do
        Given { data['start_date_local'] = (Time.current.monday + 12.hours).iso8601 }

        Then { result.is_a? Activity }
        And { user.activities.count == 1 }
        And { user.activities.last!.monday? == true }
      end

      context "when activity is on a monday" do
        Given { data['start_date_local'] = (Time.current.monday + 2.days).iso8601 }
        Then { user.activities.last!.monday? == false }
      end
    end
  end

end
