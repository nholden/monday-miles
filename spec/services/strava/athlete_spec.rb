require 'rails_helper'

RSpec.describe Strava::Athlete do

  Given(:strava_athlete) { Strava::Athlete.new(data) }
  Given(:data) { JSON.parse(file_fixture('strava/athlete_summary.json').read) }

  describe "#id" do
    When(:result) { strava_athlete.id }
    Then { result == 227615 }
  end

  describe "#first_name" do
    When(:result) { strava_athlete.first_name }
    Then { result == 'John' }
  end

  describe "#last_name" do
    When(:result) { strava_athlete.last_name }
    Then { result == 'Applestrava' }
  end

  describe "#medium_profile_image_url" do
    When(:result) { strava_athlete.medium_profile_image_url }
    Then { result == 'http://pics.com/227615/medium.jpg' }
  end

  describe "#large_profile_image_url" do
    When(:result) { strava_athlete.large_profile_image_url }
    Then { result == 'http://pics.com/227615/large.jpg' }
  end

  describe "#city" do
    When(:result) { strava_athlete.city }
    Then { result == 'San Francisco' }
  end

  describe "#state" do
    When(:result) { strava_athlete.state }
    Then { result == 'California' }
  end

  describe "#country" do
    When(:result) { strava_athlete.country }
    Then { result == 'United States' }
  end

  describe "#gender" do
    When(:result) { strava_athlete.gender }
    Then { result == 'M' }
  end

  describe "#email" do
    When(:result) { strava_athlete.email }
    Then { result == 'john@applestrava.com' }
  end

end
