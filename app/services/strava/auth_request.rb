module Strava
  module AuthRequest

    BASE_URL = 'https://www.strava.com/oauth/authorize'.freeze
    PARAMS = {
      client_id: ENV.fetch('STRAVA_CLIENT_ID'),
      redirect_uri: "#{ENV.fetch('BASE_URL')}/auth/strava/callback".freeze,
      response_type: 'code'.freeze,
    }
    URL = "#{BASE_URL}/?#{PARAMS.to_query}"

  end
end
