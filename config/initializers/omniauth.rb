OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :strava, ENV.fetch('STRAVA_CLIENT_ID'), ENV.fetch('STRAVA_API_KEY'), scope: 'public'
end
