class ActivityCreator

  DuplicateActivityError = Class.new(StandardError)

  def self.create_from_strava_activity!(strava_activity)
    if Activity.find_by_strava_id(strava_activity.id)
      raise DuplicateActivityError
    else
      # TODO
    end
  end

end
