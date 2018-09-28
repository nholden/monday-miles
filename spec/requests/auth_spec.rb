require 'rails_helper'

RSpec.describe "auth" do

  context "auth path" do
    it "redirects the user to Strava" do
      get strava_auth_request_path
      expect(response.status).to eql 301

      destination_uri = URI.parse(response.headers['Location'])
      expect(destination_uri.host).to eql 'www.strava.com'
      expect(destination_uri.path).to eql '/oauth/authorize/'
      expect(destination_uri.query).to include "client_id=" + CGI.escape("#{ENV.fetch('STRAVA_CLIENT_ID')}")
      expect(destination_uri.query).to include "redirect_uri=" + CGI.escape("#{ENV.fetch('BASE_URL')}#{Rails.application.routes.url_helpers.strava_auth_callback_path}")
      expect(destination_uri.query).to include "response_type=code"
    end
  end

  context "callback path" do
    around do |example|
      VCR.use_cassette('strava_token',
        match_requests_on: [
          :method,
          VCR.request_matchers.uri_without_params(:client_id, :client_secret),
        ],
        &example
      )
    end

    it "creates a new User from Strava data" do
      code = 'abc123'
      get "#{Rails.application.routes.url_helpers.strava_auth_callback_path}?code=#{code}"

      user = User.last!

      expect(response.status).to eql 302
      expect(user.strava_access_token).to eql "fakeaccesstoken"
      expect(user.first_name).to eql "Nick"
      expect(user.last_name).to eql "Holden"
    end
  end

end
