# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Strava::API do

  describe "#get" do
    When(:result) { Strava::API.get(path: path, access_token: access_token) }

    context "when access token is unauthorized" do
      around { |example| VCR.use_cassette('strava_unauthorized', &example) }

      Given(:path) { 'activities/10707546' }
      Given(:access_token) { 'invalid-token' }

      Then { expect(result).to have_raised(Strava::API::UnauthorizedError) }
    end
  end

  describe "#refresh_access_token" do
    When(:result) { Strava::API.refresh_access_token(refresh_token: refresh_token) }

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

      Given(:refresh_token) { 'valid-refresh-token' }

      Then { expect(result.class).to eql(Strava::AccessToken) }
      And { expect(result.access_token).to eql('fake-new-access-token') }
      And { expect(result.refresh_token).to eql('fake-new-refresh-token') }
      And { expect(result.expires_at).to eql 6.hours.from_now }
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

      Given(:refresh_token) { 'invalid-refresh-token' }

      Then { expect(result).to have_raised(Strava::API::UnauthorizedError) }
    end
  end

end
