module Strava
  class AccessToken < Struct.new(:data)

    def access_token
      data['access_token']
    end

    def expires_at
      Time.at(data['expires_at'])
    end

    def refresh_token
      data['refresh_token']
    end

  end
end
