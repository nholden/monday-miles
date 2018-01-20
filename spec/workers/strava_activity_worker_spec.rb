require 'rails_helper'

RSpec.describe StravaActivityWorker do

  Given(:worker) { StravaActivityWorker.new }

  describe "#perform" do
    Given(:strava_athlete_id) { 4197670 }
    Given(:strava_activity_id) { 1348598020 }
    Given!(:user) { FactoryGirl.create(:user, strava_id: strava_athlete_id, strava_access_token: 'faket0k3n') }

    around { |example| VCR.use_cassette('strava_activity', &example) }

    When { worker.perform(strava_athlete_id, strava_activity_id) }

    context "it creates a new activity" do
      Given(:activity) { Activity.find_by_strava_id(strava_activity_id) }
      Then { activity.present? }
      And { activity.user == user }
    end

    context "it updates an existing activity" do
      Given!(:activity) { FactoryGirl.create(:activity, strava_id: strava_activity_id, user: user, name: 'Old activity name') }
      When { activity.reload }
      Then { activity.name == 'New activity name' }
    end
  end

end
