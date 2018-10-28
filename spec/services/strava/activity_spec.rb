# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Strava::Activity do

  Given(:activity) { Strava::Activity.new(data) }
  Given(:data) { JSON.parse(file_fixture('strava/activity.json').read) }

  describe "#id" do
    When(:result) { activity.id }
    Then { result == 999582172 }
  end

  describe "#name" do
    When(:result) { activity.name }
    Then { result == 'Example Ride' }
  end

  describe "#distance" do
    When(:result) { activity.distance }
    Then { result == 122111 }
  end

  describe "#moving_time" do
    When(:result) { activity.moving_time }
    Then { result == 18748 }
  end

  describe "#elapsed_time" do
    When(:result) { activity.elapsed_time }
    Then { result == 25880 }
  end

  describe "#total_elevation_gain" do
    When(:result) { activity.total_elevation_gain }
    Then { result == 1055 }
  end

  describe "#type" do
    When(:result) { activity.type }
    Then { result == 'Ride' }
  end

  describe "#start_time" do
    Given { data['start_date'] = '2017-10-13T12:20:55Z' }
    When(:result) { activity.start_time }
    Then { result == Time.parse('2017-10-13T12:20:55Z') }
  end

  describe "#utc_offset" do
    When(:result) { activity.utc_offset }
    Then { result == -420 }
  end

  describe "#start_lat" do
    When(:result) { activity.start_lat }
    Then { result == 38.46 }
  end

  describe "#start_lng" do
    When(:result) { activity.start_lng }
    Then { result == -123.05 }
  end

  describe "#city" do
    When(:result) { activity.city }
    Then { result == 'San Francisco' }
  end

  describe "#state" do
    When(:result) { activity.state }
    Then { result == 'California' }
  end

  describe "#country" do
    When(:result) { activity.country }
    Then { result == 'United States' }
  end

  describe "#polyline" do
    When(:result) { activity.polyline }
    Then { result.include? '}_wiFh{' }
  end

  describe "#elev_high" do
    When(:result) { activity.elev_high }
    Then { result == 79.6 }
  end

  describe "#elev_low" do
    When(:result) { activity.elev_low }
    Then { result == -9.6 }
  end

  describe "#average_temp" do
    When(:result) { activity.average_temp }
    Then { result == 26 }
  end

  describe "#monday?" do
    Given { data['start_date_local'] = start_date_local }

    When(:result) { activity.monday? }

    context "when it is a Monday in the activity local time zone" do
      Given(:start_date_local) { '2017-10-09T23:59:59Z' }
      Then { result == true }
    end

    context "when it is not a Monday in the activity local time zone" do
      Given(:start_date_local) { '2017-10-10T00:00:00Z' }
      Then { result == false }
    end
  end

end
