module Strava
  class Athlete < Struct.new(:data)

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

  end
end
