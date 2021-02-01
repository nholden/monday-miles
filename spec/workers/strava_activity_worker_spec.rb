# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StravaActivityWorker do

  Given(:worker) { StravaActivityWorker.new }

  describe "#perform" do
    Given(:strava_athlete_id) { 4197670 }
    Given(:strava_activity_id) { 122027191 }
    Given!(:user) { FactoryGirl.create(:user,
                                       strava_id: strava_athlete_id,
                                       strava_access_token: 'faket0k3n',
                                       archived_at: archived_at) }

    When { worker.perform(strava_athlete_id, strava_activity_id) }

    context "when the user has is not archived" do
      Given(:archived_at) { nil }

      context "when a Strava activity with the given ID exists" do
        around { |example| VCR.use_cassette('strava_activity', &example) }

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

      context "when the Strava activity with the given ID has been deleted" do
        around { |example| VCR.use_cassette('deleted_strava_activity', &example) }

        context "it does not create a new activity" do
          Then { Activity.where(strava_id: strava_activity_id).none? }
        end

        context "it does not update an existing activity" do
          Given!(:activity) { FactoryGirl.create(:activity, strava_id: strava_activity_id, user: user, name: 'Old activity name') }
          When { activity.reload }
          Then { activity.name == 'Old activity name' }
        end
      end
    end

    context "it does not create a new activity when the user is archived" do
      around { |example| VCR.use_cassette('strava_activity', &example) }

      Given(:archived_at) { 1.day.ago }
      Then { Activity.where(strava_id: strava_activity_id).none? }
    end

    context "archives the user if Strava returns a 403" do
      around do |example|
        travel_to(Time.parse('2018-10-25T01:00:00Z')) do
          VCR.use_cassette('strava_forbidden', &example)
        end
      end

      Given(:archived_at) { nil }
      When { user.reload }
      Then { expect(user.archived_at).to eql(Time.current) }
    end
  end

end
