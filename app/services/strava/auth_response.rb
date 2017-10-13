module Strava
  class AuthResponse < Struct.new(:omniauth_hash)

    def authenticated?
      access_token.present?
    end

    def access_token
      omniauth_hash.dig(:credentials, :token)
    end

    def athlete
      if athlete_data = omniauth_hash.dig(:extra, :raw_info)
        Athlete.new(athlete_data)
      end
    end

  end
end
