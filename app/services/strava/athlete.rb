module Strava
  class Athlete < Struct.new(:data)

    MissingAccessTokenError = Class.new(StandardError)

    attr_accessor :access_token

    def id
      data['id']
    end

    def first_name
      data['firstname']
    end

    def last_name
      data['lastname']
    end

    def medium_profile_image_url
      data['profile_medium']
    end

    def large_profile_image_url
      data['profile']
    end

    def city
      data['city']
    end

    def state
      data['state']
    end

    def country
      data['country']
    end

    def gender
      data['sex']
    end

    def email
      data['email']
    end

    def activities(start_time, end_time)
      raise MissingAccessTokenError unless access_token

      response = Excon.get('https://www.strava.com/api/v3/athlete/activities',
                           headers: { 'Authorization' => "Bearer #{access_token}" },
                           query: { after: start_time.to_i, before: end_time.to_i })

      JSON.parse(response.body).map { |activity_data| Strava::Activity.new(activity_data) }
    end

  end
end
