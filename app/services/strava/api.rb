# frozen_string_literal: true

module Strava
  class API

    BadRequestError = Class.new(StandardError)
    UnauthorizedError = Class.new(StandardError)
    ForbiddenError = Class.new(StandardError)
    TooManyRequestsError = Class.new(StandardError)

    def self.get(path:, access_token:, query: {})
      response = Excon.get("https://www.strava.com/api/v3/#{path}",
                           headers: { 'Authorization' => "Bearer #{access_token}" },
                           query: query)

      parsed_response = begin
        JSON.parse(response.body)
      rescue JSON::ParserError
        nil
      end

      if response.status == 400
        raise BadRequestError, parsed_response
      elsif response.status == 401
        raise UnauthorizedError, parsed_response
      elsif response.status == 403
        raise ForbiddenError, parsed_response
      elsif response.status == 429
        raise TooManyRequestsError, parsed_response
      else
        JSON.parse(response.body)
      end
    end

    def self.refresh_access_token(refresh_token:)
      response = Excon.post('https://www.strava.com/oauth/token',
        query: {
          client_id: ENV.fetch('STRAVA_CLIENT_ID'),
          client_secret: ENV.fetch('STRAVA_CLIENT_SECRET'),
          grant_type: 'refresh_token',
          refresh_token: refresh_token,
        }
      )

      parsed_response = JSON.parse(response.body)

      # Strava responds to requests with an invalid refresh token with a
      # 400 (Bad Request) status instead of a 401 (Unauthorized) status,
      # but we should handle these responses as if they were unauthorized.
      if response.status == 401 || parsed_response["errors"]&.any? { |error| error["resource"] == "RefreshToken" }
        raise UnauthorizedError, parsed_response
      elsif response.status == 400
        raise BadRequestError, parsed_response
      else
        AccessToken.new(parsed_response)
      end
    end

  end
end
