require 'rails_helper'
require 'support/omniauth_helper'

RSpec.describe "authentication" do

  around { |example| travel_to(Time.iso8601('2017-11-22T00:00:00-07:00'), &example) }

  describe "login via Strava" do
    around { |example| use_strava_auth(auth_response_data, &example) }

    When { visit root_path }
    When { click_link 'Connect with Strava', match: :first }

    context "when authentication is successful" do
      Given(:auth_response_data) { parse_omniauth_fixture('strava/successful_omniauth_response.json') }

      context "when the user is new" do
        Given(:user) { User.find_by_strava_id!(227615) }

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
        And { user.last_signed_in_at == Time.current }
        And { user.slug == 'john-applestrava' }

        And { expect(page).to have_current_path('/loading') }
        And { StravaActivityWorker.jobs.size == 1 }
      end

      context "when the user already exists" do
        Given!(:existing_user) { FactoryGirl.create(:user,
                                                    strava_id: 227615,
                                                    strava_access_token: existing_strava_access_token,
                                                    large_profile_image_url: existing_large_profile_image_url,
                                                    last_signed_in_at: 2.days.ago) }
        Given(:existing_strava_access_token) { '83ebeabdec09f6670863766f792ead24d61fe3f9' }
        Given(:existing_large_profile_image_url) { 'http://pics.com/227615/large.jpg' }

        When { existing_user.reload }

        context "when the user's Strava data has stayed the same" do
          Given(:strava_activity_worker_args) { StravaActivityWorker.jobs.last['args'] }
          Given(:job_start_time) { strava_activity_worker_args[1] }
          Given(:job_end_time) { strava_activity_worker_args[2] }

          Then { expect(page).to have_current_path(user_profile_path(existing_user.slug)) }
          And { existing_user.last_signed_in_at == Time.current }
          And { existing_user.strava_access_token == '83ebeabdec09f6670863766f792ead24d61fe3f9' }
          And { existing_user.large_profile_image_url == 'http://pics.com/227615/large.jpg' }
          And { StravaActivityWorker.jobs.size == 1 }
          And { job_start_time == 2.days.ago.iso8601 }
          And { job_end_time == Time.current.iso8601 }
        end

        context "when the user's Strava access token has changed" do
          Given(:existing_strava_access_token) { 'abc123' }
          Then { existing_user.strava_access_token == '83ebeabdec09f6670863766f792ead24d61fe3f9' }
        end

        context "when the user's profile photo URL has changed" do
          Given(:existing_large_profile_image_url) { 'http://oldphotourl.com/old.jpg' }
          Then { existing_user.large_profile_image_url == 'http://pics.com/227615/large.jpg' }
        end
      end
    end

    context "when authentication fails" do
      Given(:auth_response_data) { parse_omniauth_fixture('strava/failed_omniauth_response.json') }

      Then { expect(page).to have_text 'Access denied' }
    end
  end

  describe "log out" do
    around { |example| use_strava_auth(parse_omniauth_fixture('strava/successful_omniauth_response.json'), &example) }

    it "should log the user out" do
      visit root_path
      click_link 'Connect with Strava', match: :first
      expect(page).to have_text 'Hi, John!'

      click_link 'Log out'
      expect(page).to_not have_text 'Hi, John!'
      expect(page).to have_text 'You have been logged out'
    end
  end

end
