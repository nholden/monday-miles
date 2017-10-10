module Strava
  class AuthResponse < Struct.new(:data)

    def authenticated?
      access_token.present?
    end

    def access_token
      data['access_token']
    end

    def athlete
      if athlete_data = data['athlete']
        Athlete.new(athlete_data)
      end
    end

  end
end
