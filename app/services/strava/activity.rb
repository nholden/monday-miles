module Strava
  class Activity < Struct.new(:data)

    def monday?
      Date.parse(data['start_date_local']).monday?
    end

  end
end
