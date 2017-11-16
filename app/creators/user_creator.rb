class UserCreator

  DuplicateUserError = Class.new(StandardError)

  def self.create_from_strava_athlete!(strava_athlete, access_token: nil)
    if user = User.find_by_strava_id(strava_athlete.id)
      raise DuplicateUserError
    else
      User.create! do |user|
        user.strava_id = strava_athlete.id
        user.first_name = strava_athlete.first_name
        user.last_name = strava_athlete.last_name
        user.medium_profile_image_url = strava_athlete.medium_profile_image_url
        user.large_profile_image_url = strava_athlete.large_profile_image_url
        user.city = strava_athlete.city
        user.state = strava_athlete.state
        user.country = strava_athlete.country
        user.gender = strava_athlete.gender
        user.email = strava_athlete.email
        user.strava_access_token = access_token
      end
    end
  end

end
