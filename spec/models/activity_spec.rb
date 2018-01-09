require 'rails_helper'

RSpec.describe Activity do

  Given(:activity) { Activity.new }

  describe "#local_start_date" do
    Given { activity.start_time = Time.parse('2018-01-02T02:30:00Z') }
    When(:result) { activity.local_start_date }

    context "when the local start date is the same as the UTC start date" do
      Given { activity.utc_offset = -120 }
      Then { result == Date.parse('2018-01-02') }
    end

    context "when the local start date is before the UTC start date" do
      Given { activity.utc_offset = -300 }
      Then { result == Date.parse('2018-01-01') }
    end
  end

end
