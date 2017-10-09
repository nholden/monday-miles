require 'rails_helper'
require 'support/omniauth_helper'

RSpec.describe "authentication" do

  describe "login via Strava" do
    around { |example| use_strava_auth(auth_response_data, &example) }

    When { visit new_session_path }
    When { click_link 'Connect with Strava' }

    context "when authentication is successful" do
      Given(:auth_response_data) { JSON.parse(file_fixture('strava/successful_auth_response.json').read) }

      Then { expect(page).to have_text 'Hi, John!' }
    end

    context "when authentication fails" do
      Given(:auth_response_data) { JSON.parse(file_fixture('strava/failed_auth_response.json').read) }

      Then { expect(page).to have_text 'Access denied' }
    end
  end

end
