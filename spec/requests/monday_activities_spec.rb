require 'rails_helper'

RSpec.describe "user monday activities request" do

  let(:user) { FactoryGirl.create(:user) }

  def activity(trait, distance:, elevation:, duration:, name:)
    FactoryGirl.create(
      :activity,
      trait,
      user: user,
      distance: distance,
      total_elevation_gain: elevation,
      moving_time: duration,
      name: name
    )
  end

  it "fetches JSON with activity data" do
    activity(:last_monday, distance: 5_000, elevation: 25, duration: 1_200, name: 'Great Monday 5k')
    activity(:two_mondays_ago, distance: 10_000, elevation: 50, duration: 3_000, name: 'Lousy Monday 10k')
    activity(:four_mondays_ago, distance: 20_000, elevation: 75, duration: 6_000, name: 'Decent Monday 20k')
    activity(:wednesday, distance: 15_000, elevation: 100, duration: 5_000, name: 'Neutral Wednesday 15k')

    get user_monday_activities_path(user), as: :json

    expect(response.status).to eql 200
    expect(response.parsed_body.length).to eql 3
    expect(response.parsed_body.first['name']).to eql 'Great Monday 5k'
    expect(response.parsed_body.first['map']).to be_present
    expect(response.parsed_body.first['miles']).to eql '3.1'
    expect(response.parsed_body.first['feetElev']).to eql '82'
    expect(response.parsed_body.first['hours']).to eql '0.3'
  end
end
