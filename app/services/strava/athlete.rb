module Strava
  class Athlete < Struct.new(:data)

    attr_accessor :access_token

    def self.from_user(user)
      new.tap do |athlete|
        athlete.data = { 'id' => user.strava_id }
        athlete.access_token = user.strava_access_token
      end
    end

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

    def activities(start_time:, end_time:)
      AthleteActivities.new(access_token: access_token, start_time: start_time, end_time: end_time).activities
    end
  end
end
