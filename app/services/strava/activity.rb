module Strava
  class Activity < Struct.new(:data)

    def self.fetch(strava_activity_id:, access_token:)
      response = Excon.get(
        "https://www.strava.com/api/v3/activities/#{strava_activity_id}",
        headers: { 'Authorization' => "Bearer #{access_token}" }
      )

      new(JSON.parse(response.body))
    end

    def id
      data['id']
    end

    def name
      data['name']
    end

    def distance
      data['distance']
    end

    def moving_time
      data['moving_time']
    end

    def elapsed_time
      data['elapsed_time']
    end

    def total_elevation_gain
      data['total_elevation_gain']
    end

    def type
      data['type']
    end

    def start_time
      Time.parse(data['start_date'])
    end

    def utc_offset
      data['utc_offset'] / 60
    end

    def start_lat
      data['start_latitude']
    end

    def start_lng
      data['start_longitude']
    end

    def city
      data['location_city']
    end

    def state
      data['location_state']
    end

    def country
      data['location_country']
    end

    def polyline
      data.dig('map', 'summary_polyline')
    end

    def elev_high
      data['elev_high']
    end

    def elev_low
      data['elev_low']
    end

    def average_temp
      data['average_temp']
    end

    def monday?
      Time.parse(data['start_date_local']).monday?
    end

    def deleted?
      data['message'] == 'Record Not Found'
    end

  end
end
