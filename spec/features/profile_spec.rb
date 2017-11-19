require 'rails_helper'

RSpec.describe "user profiles" do

  around { |example| travel_to(Time.new(2017, 11, 18), &example) }

  Given(:user) { FactoryGirl.create(:user) }
  When { visit user_profile_path(user) }

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

  context "for a user with activities" do
    Given { activity(:last_monday, distance: 5_000, elevation: 25, duration: 1_200, name: 'Great Monday 5k') }
    Given { activity(:two_mondays_ago, distance: 10_000, elevation: 50, duration: 3_000, name: 'Lousy Monday 10k') }
    Given { activity(:four_mondays_ago, distance: 20_000, elevation: 75, duration: 6_000, name: 'Decent Monday 20k') }
    Given { activity(:wednesday, distance: 15_000, elevation: 100, duration: 5_000, name: 'Neutral Wednesday 15k') }

    Then { expect(page).to have_text 'Streak 2 activities' }
    And { expect(page).to have_text '21.7 miles' }
    And { expect(page).to have_text '492 feet elev.' }
    And { expect(page).to have_text '2.8 hours' }
    And { expect(page).to have_text '3 activities' }
  end

end