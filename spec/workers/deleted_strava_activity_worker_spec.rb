# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeletedStravaActivityWorker do

  Given(:worker) { DeletedStravaActivityWorker.new }

  describe "#perform" do
    Given(:strava_athlete_id) { 4197670 }
    Given(:strava_activity_id) { 122027191 }
    Given!(:user) { FactoryGirl.create(:user, strava_id: strava_athlete_id, strava_access_token: 'faket0k3n') }

    When(:result) { worker.perform(strava_athlete_id, strava_activity_id) }

    context "it updates deleted_at for an existing activity" do
      around { |example| VCR.use_cassette('deleted_strava_activity', &example) }

      Given!(:activity) { FactoryGirl.create(:activity, strava_id: strava_activity_id, user: user, deleted_at: nil) }
      When { activity.reload }
      Then { activity.deleted_at.present? }
    end

    context "it ignores the webhook if no matching activity exists" do
      around { |example| VCR.use_cassette('deleted_strava_activity', &example) }

      Then { expect(result).to_not have_raised }
    end

    context "archives the user if Strava returns a 403" do
      around do |example|
        travel_to(Time.parse('2018-10-25T01:00:00Z')) do
          VCR.use_cassette('strava_forbidden', &example)
        end
      end

      When { user.reload }
      Then { expect(result).to_not have_raised }
      And { expect(user.archived_at).to eql(Time.current) }
    end
  end
end
