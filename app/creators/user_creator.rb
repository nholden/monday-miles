class UserCreator

  def self.find_or_create_from_strava_athlete!(strava_athlete)
    if user = User.find_by_strava_id(strava_athlete.id)
      user
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
      end
    end
  end

end
