module Strava
  class AuthResponse < Struct.new(:data)

    def authenticated?
      access_token.present?
    end

    def access_token
      data['access_token']
    end

    def first_name
      data.dig('athlete', 'firstname')
    end

  end
end
