module Strava
  class Activity < Struct.new(:data)

    def id
      data['id']
    end

    def monday?
      Date.parse(data['start_date_local']).monday?
    end

  end
end
