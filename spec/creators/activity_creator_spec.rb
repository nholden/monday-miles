require 'rails_helper'

RSpec.describe ActivityCreator do

  describe ".create_from_strava_activity!" do
    Given(:strava_activity) { Strava::Activity.new(data) }
    Given(:data) { JSON.parse(file_fixture('strava/activity.json').read) }
    Given(:user) { FactoryGirl.create(:user) }

    When(:result) { ActivityCreator.create_from_strava_activity!(strava_activity, user: user) }

    context "when matching activity exists" do
      Given!(:existing_activity) { FactoryGirl.create(:activity, strava_id: 999582172) }
      Then { expect(result).to have_raised ActivityCreator::DuplicateActivityError }
    end

    context "when matching activity does not exist" do
      Then { result.is_a? Activity }
      And { user.activities.count == 1 }
    end
  end

end
