# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Strava::Athlete do

  Given(:strava_athlete) { Strava::Athlete.new(data) }
  Given(:data) { JSON.parse(file_fixture('strava/athlete_summary.json').read) }

  describe ".from_user" do
    Given(:user) { FactoryGirl.create(:user, strava_id: 100, strava_access_token: 'acc3$$') }

    When(:result) { Strava::Athlete.from_user(user) }

    Then { result.is_a? Strava::Athlete }
    And { result.id == 100 }
    And { result.access_token == 'acc3$$' }
  end

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

    context "when Strava returns an absolute URL to a real photo" do
      Then { result == 'http://pics.com/227615/medium.jpg' }
    end

    context "when Strava returns a relative path to a default avatar" do
      Given { data['profile_medium'] = '/avatar/athlete/medium.png' }
      Then { result.nil? }
    end
  end

  describe "#large_profile_image_url" do
    When(:result) { strava_athlete.large_profile_image_url }

    context "when Strava returns an absolute URL to a real photo" do
      Then { result == 'http://pics.com/227615/large.jpg' }
    end

    context "when Strava returns a relative path to a default avatar" do
      Given { data['profile'] = '/avatar/athlete/large.png' }
      Then { result.nil? }
    end
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

  describe "#activities" do
    around { |example| travel_to(Time.iso8601('2017-10-14T00:00:00-07:00'), &example) }

    Given(:start_time) { 1.week.ago }
    Given(:end_time) { Time.current }

    When(:result) { strava_athlete.activities(start_time: start_time, end_time: end_time) }

    context "when the athlete doesn't have an access token" do
      Given { strava_athlete.access_token = nil }
      Then { expect(result).to have_raised(Strava::AthleteActivities::MissingAccessTokenError) }
    end

    context "with an access token" do
      Given { strava_athlete.access_token = '00accesstoken00' }

      context "for the last week" do
        around { |example| VCR.use_cassette('strava_athlete_activities_week', &example) }

        Then { result.all? { |result| result.is_a? Strava::Activity } }
        And { result.all? { |result| result.start_time >= start_time && result.start_time <= end_time } }
      end

      context "for a previous fortnight" do
        around { |example| VCR.use_cassette('strava_athlete_activities_fortnight', &example) }

        Given(:start_time) { 3.weeks.ago }
        Given(:end_time) { 1.week.ago }

        Then { result.all? { |result| result.is_a? Strava::Activity } }
        And { result.all? { |result| result.start_time >= start_time && result.start_time <= end_time } }
      end

      context "when fetching all activities in time period requires multiple API calls" do
        around { |example| VCR.use_cassette('strava_athlete_activities_two_years', &example) }

        Given(:start_time) { 2.years.ago }

        Then { result.all? { |result| result.is_a? Strava::Activity } }
        And { result.all? { |result| result.start_time >= start_time && result.start_time <= end_time } }
        And { result.count > Strava::AthleteActivities::MAX_ACTIVITIES_PER_API_CALL }
      end
    end
  end

end
