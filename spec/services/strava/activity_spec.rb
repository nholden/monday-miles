require 'rails_helper'

RSpec.describe Strava::Activity do

  Given(:activity) { Strava::Activity.new(data) }
  Given(:data) { JSON.parse(file_fixture('strava/activity.json').read) }

  describe "#id" do
    When(:result) { activity.id }
    Then { result == 999582172 }
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
