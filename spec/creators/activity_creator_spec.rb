require 'rails_helper'

RSpec.describe ActivityCreator do

  describe ".create_from_strava_activity!" do
    Given(:strava_activity) { Strava::Activity.new(data) }
    Given(:data) { JSON.parse(file_fixture('strava/activity.json').read) }

    When(:result) { ActivityCreator.create_from_strava_activity!(strava_activity) }

    context "when matching activity exists" do
      Given!(:existing_activity) { FactoryGirl.create(:activity, strava_id: 999582172) }
      Then { expect(result).to have_raised ActivityCreator::DuplicateActivityError }
    end

    context "when matching activity does not exist" do
      Given(:activity) { Activity.find_by_strava_id!(999582172) }

      # TODO
    end
  end

end
