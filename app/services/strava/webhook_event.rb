module Strava
  class WebhookEvent < Struct.new(:data)

    ACTIVITY_STRAVA_OBJECT_TYPE = 'activity'.freeze
    CREATE_ASPECT_TYPE = 'create'.freeze
    UPDATE_ASPECT_TYPE = 'update'.freeze
    DELETE_ASPECT_TYPE = 'delete'.freeze

    def created_activity?
      strava_object_type == ACTIVITY_STRAVA_OBJECT_TYPE && aspect_type == CREATE_ASPECT_TYPE
    end

    def strava_athlete_id
      owner_id if strava_object_type == ACTIVITY_STRAVA_OBJECT_TYPE
    end

    def strava_activity_id
      strava_object_id if strava_object_type == ACTIVITY_STRAVA_OBJECT_TYPE
    end

    private

    def strava_object_type
      data['object_type']
    end

    def aspect_type
      data['aspect_type']
    end

    def owner_id
      data['owner_id'].to_i
    end

    def strava_object_id
      data['object_id'].to_i
    end

  end
end
