# frozen_string_literal: true

module Strava
  class WebhookEvent < Struct.new(:data)

    ACTIVITY_STRAVA_OBJECT_TYPE = 'activity'
    CREATE_ASPECT_TYPE = 'create'
    UPDATE_ASPECT_TYPE = 'update'
    DELETE_ASPECT_TYPE = 'delete'

    def created_or_updated_activity?
      strava_object_type == ACTIVITY_STRAVA_OBJECT_TYPE &&
        aspect_type.in?([CREATE_ASPECT_TYPE, UPDATE_ASPECT_TYPE])
    end

    def deleted_activity?
      strava_object_type == ACTIVITY_STRAVA_OBJECT_TYPE && aspect_type == DELETE_ASPECT_TYPE
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
