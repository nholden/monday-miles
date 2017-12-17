require 'rails_helper'

RSpec.describe "user monday activities request" do

  let(:user) { FactoryGirl.create(:user) }

  def activity(trait, distance:, elevation:, seconds:, name:, strava_id:)
    FactoryGirl.create(
      :activity,
      trait,
      user: user,
      distance: distance,
      total_elevation_gain: elevation,
      moving_time: seconds,
      name: name,
      strava_id: strava_id
    )
  end

  it "fetches JSON with activity data" do
    activity(:last_monday, distance: 5_000, elevation: 25, seconds: 1_200, name: 'Great Monday 5k', strava_id: 123)
    activity(:two_mondays_ago, distance: 10_000, elevation: 50, seconds: 3_000, name: 'Lousy Monday 10k', strava_id: 456)
    activity(:four_mondays_ago, distance: 20_000, elevation: 75, seconds: 6_000, name: 'Decent Monday 20k', strava_id: 789)
    activity(:wednesday, distance: 15_000, elevation: 100, seconds: 5_000, name: 'Neutral Wednesday 15k', strava_id: 135)

    get user_monday_activities_path(user.slug), as: :json

    expect(response.status).to eql 200
    expect(response.parsed_body.length).to eql 3
    expect(response.parsed_body.first['name']).to eql 'Great Monday 5k'
    expect(response.parsed_body.first['map']).to be_present
    expect(response.parsed_body.first['miles']).to eql '3.1'
    expect(response.parsed_body.first['feetElev']).to eql '82'
    expect(response.parsed_body.first['duration']).to eql '20:00'
    expect(response.parsed_body.first['stravaUrl']).to eql 'https://www.strava.com/activities/123'
  end
end
