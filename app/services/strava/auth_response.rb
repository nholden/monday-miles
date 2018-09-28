module Strava
  class AuthResponse < Struct.new(:parsed_oauth_response)

    def authenticated?
      access_token.present?
    end

    def access_token
      parsed_oauth_response["access_token"]
    end

    def athlete
      if athlete_data = parsed_oauth_response["athlete"]
        Athlete.new(athlete_data)
      end
    end

  end
end
