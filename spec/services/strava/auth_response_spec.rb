require 'rails_helper'

RSpec.describe Strava::AuthResponse do

  Given(:auth_response) { Strava::AuthResponse.new(response_data) }
  Given(:successful_response_data) { JSON.parse(file_fixture('strava/successful_auth_response.json').read) }
  Given(:failed_response_data) { JSON.parse(file_fixture('strava/failed_auth_response.json').read) }

  describe "#authenticated?" do
    When(:result) { auth_response.authenticated? }

    context "when authentication is successful" do
      Given(:response_data) { successful_response_data }
      Then { result == true }
    end

    context "when authentication fails" do
      Given(:response_data) { failed_response_data }
      Then { result == false }
    end
  end

  describe "#access_token" do
    When(:result) { auth_response.access_token }

    context "when authentication is successful" do
      Given(:response_data) { successful_response_data }
      Then { result == "83ebeabdec09f6670863766f792ead24d61fe3f9" }
    end

    context "when authentication fails" do
      Given(:response_data) { failed_response_data }
      Then { result.nil? }
    end
  end

  describe "#first_name" do
    When(:result) { auth_response.first_name }

    context "when authentication is successful" do
      Given(:response_data) { successful_response_data }
      Then { result == 'John' }
    end

    context "when authentication fails" do
      Given(:response_data) { failed_response_data }
      Then { result.nil? }
    end
  end
end
