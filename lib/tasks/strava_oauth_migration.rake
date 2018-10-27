# http://developers.strava.com/docs/oauth-updates/#migration-instructions
task :migrate_users_to_strava_refresh_tokens => :environment do
  updated_user_count = 0
  errored_user_ids = []

  User.where(strava_refresh_token: nil).each do |user|
    begin
      access_token = Strava::API.refresh_access_token(refresh_token: user.strava_access_token)

      user.update!(
        strava_access_token: access_token.access_token,
        strava_access_token_expires_at: access_token.expires_at,
        strava_refresh_token: access_token.refresh_token
      )

      updated_user_count += 1
    rescue Strava::API::BadRequestError => ex
      Rails.logger.info "[migrate_users_to_strava_refresh_tokens] Rescued Strava::API::BadRequestError: #{ex.message}. Did user #{user.id} revoke access?"
      errored_user_ids += [user.id]
    end
  end

  puts "[migrate_users_to_strava_refresh_tokens] Migrated #{updated_user_count} users to Strava refresh tokens"
  puts "[migrate_users_to_strava_refresh_tokens] Errored user IDs: #{errored_user_ids}"
end
