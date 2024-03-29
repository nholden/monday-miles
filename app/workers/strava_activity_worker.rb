# frozen_string_literal: true

class StravaActivityWorker

  include Sidekiq::Worker

  def perform(strava_athlete_id, strava_activity_id)
    user = User.find_by_strava_id!(strava_athlete_id)

    if user.archived?
      logger.info "[StravaActivityWorker] User #{user.id} is archived. Not creating Activity record for Strava activity with ID #{strava_activity_id}."
    else
      begin
        strava_activity = Strava::Activity.fetch(
          strava_activity_id: strava_activity_id,
          access_token: user.refresh_strava_access_token!
        )
      rescue Strava::API::ForbiddenError => ex
        Rails.logger.info "[StravaActivityWorker] Rescued Strava::API::ForbiddenError: #{ex.message}. Archiving user #{user.id}."
        user.archive!
        return
      rescue Strava::API::TooManyRequestsError => ex
        Rails.logger.info "[StravaActivityWorker] Rescued Strava::API::TooManyRequestsError: #{ex.message}."
        return
      end

      if strava_activity.deleted?
        logger.info "[StravaActivityWorker] Strava activity with ID #{strava_activity_id} not found. Not creating or updating Activity record."
      else
        if strava_activity.monday?
          Activity.from_strava_activity(strava_activity, user: user).save!
        end
      end
    end
  end

end
