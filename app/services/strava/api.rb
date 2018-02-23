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

  end
end
