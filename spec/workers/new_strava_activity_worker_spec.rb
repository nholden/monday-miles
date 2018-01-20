require 'rails_helper'

RSpec.describe NewStravaActivityWorker do

  Given(:worker) { NewStravaActivityWorker.new }

  describe "#perform" do
    When { worker.perform(strava_athlete_id, strava_activity_id) }

    context "it creates a new activity" do
      around { |example| VCR.use_cassette('strava_activity', &example) }

      Given(:strava_athlete_id) { 4197670 }
      Given(:strava_activity_id) { 1348598020 }
      Given!(:user) { FactoryGirl.create(:user, strava_id: strava_athlete_id, strava_access_token: 'faket0k3n') }
      Given(:activity) { Activity.find_by_strava_id(strava_activity_id) }

      Then { activity.present? }
      And { activity.user == user }
    end
  end

end
