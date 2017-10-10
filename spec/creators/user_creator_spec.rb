require 'rails_helper'

RSpec.describe UserCreator do

  describe ".find_or_create_from_strava_athlete!" do
    Given(:strava_athlete) { Strava::Athlete.new(athlete_data) }
    Given(:athlete_data) { JSON.parse(file_fixture('strava/athlete_summary.json').read) }

    When(:result) { UserCreator.find_or_create_from_strava_athlete!(strava_athlete) }

    context "when matching user exists" do
      Given!(:existing_user) { FactoryGirl.create(:user, strava_id: 227615) }
      Then { result == existing_user }
    end

    context "when matching user does not exist" do
      Given(:user) { User.find_by_strava_id!(227615) }

      Then { user.first_name == 'John' }
      And { user.last_name == 'Applestrava' }
      And { user.medium_profile_image_url == 'http://pics.com/227615/medium.jpg' }
      And { user.large_profile_image_url == 'http://pics.com/227615/large.jpg' }
      And { user.city == 'San Francisco' }
      And { user.state == 'California' }
      And { user.country == 'United States' }
      And { user.gender == 'M' }
      And { user.email == 'john@applestrava.com' }
    end
  end

end
