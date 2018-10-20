module Strava
  module AuthRequest

    BASE_URL = 'https://www.strava.com/oauth/authorize'.freeze

    # https://developers.strava.com/docs/authentication/#request-access
    SCOPES = [
      # profile:read_all: read all profile information even if the user has set
      # their profile visibility to Followers or Only You
      PROFILE_READ_ALL_SCOPE = 'profile:read_all'.freeze,

      # activity:read: read the user's activity data for activities that are
      # visible to Everyone and Followers, excluding privacy zone data
      ACTIVITY_READ_SCOPE = 'activity:read'.freeze,
    ]

    PARAMS = {
      client_id: ENV.fetch('STRAVA_CLIENT_ID'),
      redirect_uri: "#{ENV.fetch('BASE_URL')}/auth/strava/callback".freeze,
      response_type: 'code'.freeze,
      scope: SCOPES.join(',').freeze,
    }

    URL = "#{BASE_URL}/?#{PARAMS.to_query}"

  end
end
