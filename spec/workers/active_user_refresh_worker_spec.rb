# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveUserRefreshWorker do

  Given(:worker) { ActiveUserRefreshWorker.new }

  describe "#perform" do
    Given!(:user) {
      FactoryGirl.create(
        :user,
        archived_at: archived_at,
        strava_refresh_token: refresh_token,
        strava_access_token_expires_at: 2.hours.ago
      )
    }

    When { worker.perform }
    When { user.reload }

    context "doesn't refresh an archived user" do
      Given(:archived_at) { 1.month.ago }
      Given(:refresh_token) { 'valid-refresh-token' }

      Then { user.activities.none? }
    end

    context "refreshes an active user with a valid refresh token" do
      around do |example|
        travel_to(Time.parse('2018-10-25T01:00:00Z')) do
          VCR.use_cassette('strava_token_refresh_authorized',
            match_requests_on: [
              :method,
              VCR.request_matchers.uri_without_params(:client_id, :client_secret),
            ]
          ) do
            example.run
          end
        end
      end

      Given(:archived_at) { nil }
      Given(:refresh_token) { 'valid-refresh-token' }

      Then { StravaActivitiesInTimeRangeWorker.jobs.one? }
      And { user.archived_at == nil }
    end

    context "archives an active user with an invalid refresh token" do
      around do |example|
        travel_to(Time.parse('2018-10-25T01:00:00Z')) do
          VCR.use_cassette('strava_token_refresh_unauthorized',
            match_requests_on: [
              :method,
              VCR.request_matchers.uri_without_params(:client_id, :client_secret),
            ]
          ) do
            example.run
          end
        end
      end

      Given(:archived_at) { nil }
      Given(:refresh_token) { 'invalid-refresh-token' }

      Then { StravaActivitiesInTimeRangeWorker.jobs.none? }
      And { user.archived_at == Time.current }
    end
  end

end
