module Strava
  class Activity < Struct.new(:data)

    def id
      data['id']
    end

    def monday?
      Time.parse(data['start_date_local']).monday?
    end

    def start_time
      Time.parse(data['start_date'])
    end

  end
end
