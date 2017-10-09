module OmniAuthHelper

  def use_strava_auth(data, &example)
    OmniAuth.config.mock_auth[:strava] = OmniAuth::AuthHash.new(data)
    example.call
    OmniAuth.config.mock_auth[:strava] = nil
  end

end

RSpec.configure do |config|
  config.include OmniAuthHelper
end
