require 'rails_helper'

RSpec.describe "Strava webhook callback" do

  it "returns a 200 status" do
    post strava_webhook_callbacks_path
    expect(response.status).to eql 200
  end

  it "creates new activities" do
    params = JSON.parse(file_fixture('strava/created_activity_webhook_event.json').read)
    params['owner_id'] = 123456
    params['object_id'] = 12345678
    post strava_webhook_callbacks_path, params: params

    expect(NewStravaActivityWorker.jobs.size).to eql 1
    worker_args = NewStravaActivityWorker.jobs.last['args']
    expect(worker_args[0]).to eql 123456
    expect(worker_args[1]).to eql 12345678
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
