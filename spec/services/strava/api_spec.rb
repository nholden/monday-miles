require 'rails_helper'

RSpec.describe Strava::API do

  describe "#get" do
    When(:result) { Strava::API.get(path: path, access_token: access_token) }

    context "when access token is unauthorized" do
      around { |example| VCR.use_cassette('strava_unauthorized', &example) }

      Given(:path) { 'activities/10707546' }
      Given(:access_token) { 'invalid-token' }

      Then { expect(result).to have_raised(Strava::API::AuthorizationError) }
    end
  end

end
