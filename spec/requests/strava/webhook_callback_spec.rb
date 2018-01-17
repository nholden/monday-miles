require 'rails_helper'

RSpec.describe "Strava webhook callback" do

  it "returns a 200 status" do
    post strava_webhook_callbacks_path
    expect(response.status).to eql 200
  end

  it "responds to a webhook subscription response with the challenge" do
    get strava_webhook_callbacks_path, params: {
      'hub.mode' => 'subscribe',
      'hub.verify_token' => 'STRAVA',
      'hub.challenge' => '15f7d1a91c1f40f8a748fd134752feb3'
    }

    expect(response.status).to eql 200
    expect(response.parsed_body['hub.challenge']).to eql '15f7d1a91c1f40f8a748fd134752feb3'
  end

end
