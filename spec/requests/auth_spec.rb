require 'rails_helper'

RSpec.describe "auth" do

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
