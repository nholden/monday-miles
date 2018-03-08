require 'rails_helper'

RSpec.describe "user profiles" do

  around { |example| travel_to(Time.iso8601('2017-11-18T00:00:00-07:00'), &example) }

  Given(:user) { FactoryGirl.create(:user, large_profile_image_url: large_profile_image_url) }
  Given(:large_profile_image_url) { 'https://dgalywyr863hv.cloudfront.net/pictures/athletes/4197670/1346139/6/large.jpg' }

  When { visit user_profile_path(user.slug) }

  def activity(trait, distance:, elevation:, seconds:, name:)
    FactoryGirl.create(
      :activity,
      trait,
      user: user,
      distance: distance,
      total_elevation_gain: elevation,
      moving_time: seconds,
      name: name
    )
  end

  context "for a user with activities" do
    Given { activity(:last_monday, distance: 5_000, elevation: 25, seconds: 1_200, name: 'Great Monday 5k') }
    Given { activity(:two_mondays_ago, distance: 10_000, elevation: 50, seconds: 3_000, name: 'Lousy Monday 10k') }
    Given { activity(:four_mondays_ago, distance: 20_000, elevation: 75, seconds: 6_000, name: 'Decent Monday 20k') }
    Given { activity(:wednesday, distance: 15_000, elevation: 100, seconds: 5_000, name: 'Neutral Wednesday 15k') }

    Then { expect(page).to have_text 'Streak 2 Nov. 6, 2017 to Nov. 13, 2017' }
  end

  context "for a user without a profile photo" do
    Given(:large_profile_image_url) { nil }
    Then { page.status_code == 200 }
  end

end
