require 'rails_helper'

RSpec.describe DeletedStravaActivityWorker do

  Given(:worker) { DeletedStravaActivityWorker.new }

  describe "#perform" do
    Given(:strava_athlete_id) { 12005087 }
    Given(:strava_activity_id) { 1363879553 }
    Given!(:user) { FactoryGirl.create(:user, strava_id: strava_athlete_id, strava_access_token: 'faket0k3n') }

    around { |example| VCR.use_cassette('deleted_strava_activity', &example) }

    When { worker.perform(strava_athlete_id, strava_activity_id) }

    context "it updates deleted_at for an existing activity" do
      Given!(:activity) { FactoryGirl.create(:activity, strava_id: strava_activity_id, user: user, deleted_at: nil) }
      When { activity.reload }
      Then { activity.deleted_at.present? }
    end
  end

end
