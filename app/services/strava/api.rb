module Strava
  class API

    AuthorizationError = Class.new(StandardError)

    def self.get(path:, access_token:, query: {})
      response = Excon.get("https://www.strava.com/api/v3/#{path}",
                           headers: { 'Authorization' => "Bearer #{access_token}" },
                           query: query)

      if response.status == 401
        raise AuthorizationError, JSON.parse(response.body)
      else
        JSON.parse(response.body)
      end
    end

    def self.refresh_access_token(refresh_token:)
      response = Excon.post('https://www.strava.com/oauth/token'.freeze,
        query: {
          client_id: ENV.fetch('STRAVA_CLIENT_ID'),
          client_secret: ENV.fetch('STRAVA_CLIENT_SECRET'),
          grant_type: 'refresh_token'.freeze,
          refresh_token: refresh_token,
        }
      )

      parsed_response = JSON.parse(response.body)

      if response.status != 200
        raise AuthorizationError, parsed_response
      else
        AccessToken.new(parsed_response)
      end
    end

  end
end
