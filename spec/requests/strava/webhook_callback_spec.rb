require 'rails_helper'

RSpec.describe "Strava webhook callback" do

  it "returns a 200 status" do
    post strava_webhook_callbacks_path
    expect(response.status).to eql 200
  end

end
