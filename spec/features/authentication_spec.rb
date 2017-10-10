require 'rails_helper'
require 'support/omniauth_helper'

RSpec.describe "authentication" do

  describe "login via Strava" do
    around { |example| use_strava_auth(auth_response_data, &example) }

    When { visit new_session_path }
    When { click_link 'Connect with Strava' }

    context "when authentication is successful" do
      Given(:auth_response_data) { JSON.parse(file_fixture('strava/successful_auth_response.json').read) }

      context "when the user is new" do
        Given(:user) { User.find_by_strava_id!(auth_response_data['athlete']['id']) }

        Then { expect(page).to have_text 'Hi, John!' }
        And { user.first_name == 'John' }
        And { user.last_name == 'Applestrava' }
        And { user.medium_profile_image_url == 'http://pics.com/227615/medium.jpg' }
        And { user.large_profile_image_url == 'http://pics.com/227615/large.jpg' }
        And { user.city == 'San Francisco' }
        And { user.state == 'California' }
        And { user.country == 'United States' }
        And { user.gender == 'M' }
        And { user.email == 'john@applestrava.com' }
        And { user.strava_access_token == '83ebeabdec09f6670863766f792ead24d61fe3f9' }
      end

      context "when the user already exists" do
        Given!(:existing_user) { FactoryGirl.create(:user,
                                                    strava_id: 227615,
                                                    strava_access_token: strava_access_token,
                                                    first_name: 'Jane') }

        When { existing_user.reload }

        context "when the user's Strava access token is the same" do
          Given(:strava_access_token) { '83ebeabdec09f6670863766f792ead24d61fe3f9' }

          Then { expect(page).to have_text 'Hi, Jane!' }
          And { existing_user.strava_access_token == '83ebeabdec09f6670863766f792ead24d61fe3f9' }
        end

        context "when the user's Strava access token has changed" do
          Given(:strava_access_token) { 'abc123' }

          Then { expect(page).to have_text 'Hi, Jane!' }
          And { existing_user.strava_access_token == '83ebeabdec09f6670863766f792ead24d61fe3f9' }
        end
      end
    end

    context "when authentication fails" do
      Given(:auth_response_data) { JSON.parse(file_fixture('strava/failed_auth_response.json').read) }

      Then { expect(page).to have_text 'Access denied' }
    end
  end

end
