require 'rails_helper'

RSpec.describe "user monday activities request" do

  around { |example| travel_to(Time.iso8601('2018-01-17T00:00:00-07:00'), &example) }

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

  before do
    activity(:last_monday, distance: 5_000, elevation: 25, seconds: 1_200, name: 'Great Monday 5k', strava_id: 123)
    activity(:two_mondays_ago, distance: 10_000, elevation: 50, seconds: 3_000, name: 'Lousy Monday 10k', strava_id: 456)
    activity(:four_mondays_ago, distance: 20_000, elevation: 75, seconds: 6_000, name: 'Decent Monday 20k', strava_id: 789)
    activity(:wednesday, distance: 15_000, elevation: 100, seconds: 5_000, name: 'Neutral Wednesday 15k', strava_id: 135)
  end

  it "fetches JSON with activity data for current year" do
    get user_monday_activities_path(user.slug), as: :json

    summary = response.parsed_body['summary']
    mondays = response.parsed_body['mondays']
    activities = response.parsed_body['activities']

    expect(response.status).to eql 200

    expect(summary['activityCount']).to eql 2
    expect(summary['miles']).to eql '9.3'
    expect(summary['feetElev']).to eql '246'
    expect(summary['hours']).to eql '1.2'

    expect(mondays.count).to eql 53
    expect(mondays.first['year']).to eql 2018
    expect(mondays.first['month']).to eql 1
    expect(mondays.first['day']).to eql 1
    expect(mondays.first['display']).to eql "Jan. 1, 2018"

    expect(activities.length).to eql 2
    expect(activities.first['name']).to eql 'Great Monday 5k'
    expect(activities.first['map']).to be_present
    expect(activities.first['miles']).to eql '3.1'
    expect(activities.first['feetElev']).to eql '82'
    expect(activities.first['duration']).to eql '20:00'
    expect(activities.first['stravaUrl']).to eql 'https://www.strava.com/activities/123'
    expect(activities.first['date']).to eql 'Jan. 15, 2018'
    expect(activities.first['day']).to eql 15
    expect(activities.first['month']).to eql 1
    expect(activities.first['year']).to eql 2018
  end

  it "fetches JSON with activity data for previous year" do
    get user_monday_activities_path(user.slug, year: 2017), as: :json

    summary = response.parsed_body['summary']
    activities = response.parsed_body['activities']

    expect(response.status).to eql 200

    expect(summary['activityCount']).to eql 1
    expect(summary['miles']).to eql '12.4'
    expect(summary['feetElev']).to eql '246'
    expect(summary['hours']).to eql '1.7'

    expect(activities.length).to eql 1
    expect(activities.first['name']).to eql 'Decent Monday 20k'
    expect(activities.first['map']).to be_present
    expect(activities.first['miles']).to eql '12.4'
    expect(activities.first['feetElev']).to eql '246'
    expect(activities.first['duration']).to eql '1:40:00'
    expect(activities.first['stravaUrl']).to eql 'https://www.strava.com/activities/789'
  end
end
