module OmniAuthHelper

  def parse_omniauth_fixture(fixture_path)
    JSON.parse(file_fixture(fixture_path).read).deep_symbolize_keys
  end

  def use_strava_auth(data, &example)
    OmniAuth.config.mock_auth[:strava] = OmniAuth::AuthHash.new(data)
    example.call
    OmniAuth.config.mock_auth[:strava] = nil
  end

end

RSpec.configure do |config|
  config.include OmniAuthHelper
end
