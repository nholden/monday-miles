module Strava
  class API

    BadRequestError = Class.new(StandardError)
    UnauthorizedError = Class.new(StandardError)

    def self.get(path:, access_token:, query: {})
      response = Excon.get("https://www.strava.com/api/v3/#{path}",
                           headers: { 'Authorization' => "Bearer #{access_token}" },
                           query: query)

      parsed_response = JSON.parse(response.body)

      if response.status == 400
        raise BadRequestError, parsed_response
      elsif response.status == 401
        raise UnauthorizedError, parsed_response
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

      if response.status == 400
        raise BadRequestError, parsed_response
      elsif response.status == 401
        raise UnauthorizedError, parsed_response
      else
        AccessToken.new(parsed_response)
      end
    end

  end
end
