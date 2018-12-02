# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do

  describe "#refresh_strava_access_token!" do
    context "when refresh token is valid" do
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

      Given(:user) { FactoryGirl.create(:user,
        strava_access_token: 'original-access-token',
        strava_access_token_expires_at: expires_at,
        strava_refresh_token: 'valid-refresh-token'
      ) }

      When(:result) { user.refresh_strava_access_token! }

      context "when access token expires more than an hour from now" do
        Given(:expires_at) { 2.hours.from_now }

        Then { result == 'original-access-token' }
        And { user.strava_access_token == 'original-access-token' }
        And { user.strava_access_token_expires_at == expires_at }
        And { user.strava_refresh_token == 'valid-refresh-token' }
      end

      context "when access token expires within an hour" do
        Given(:expires_at) { 45.minutes.from_now }

        Then { result == 'fake-new-access-token' }
        And { user.strava_access_token == 'fake-new-access-token' }
        And { user.strava_access_token_expires_at == 6.hours.from_now }
        And { user.strava_refresh_token == 'fake-new-refresh-token' }
      end

      context "when access token is expired" do
        Given(:expires_at) { 45.minutes.ago }

        Then { result == 'fake-new-access-token' }
        And { user.strava_access_token == 'fake-new-access-token' }
        And { user.strava_access_token_expires_at == 6.hours.from_now }
        And { user.strava_refresh_token == 'fake-new-refresh-token' }
      end
    end

    context "when refresh token is invalid" do
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

      Given(:user) { FactoryGirl.create(:user,
        strava_access_token: 'original-access-token',
        strava_access_token_expires_at: expires_at,
        strava_refresh_token: 'invalid-refresh-token'
      ) }

      When(:result) { user.refresh_strava_access_token! }

      context "when access token expires more than an hour from now" do
        Given(:expires_at) { 2.hours.from_now }

        Then { result == 'original-access-token' }
        And { user.strava_access_token == 'original-access-token' }
        And { user.strava_access_token_expires_at == expires_at }
        And { user.strava_refresh_token == 'invalid-refresh-token' }
      end

      context "when access token is expired" do
        Given(:expires_at) { 45.minutes.ago }
        Then { expect(result).to have_raised(Strava::API::UnauthorizedError) }
      end
    end
  end

end
