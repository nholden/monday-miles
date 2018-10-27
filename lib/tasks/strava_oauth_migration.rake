# http://developers.strava.com/docs/oauth-updates/#migration-instructions
task :migrate_users_to_strava_refresh_tokens => :environment do
  updated_user_count = 0

  User.where(strava_refresh_token: nil).each do |user|
    access_token = Strava::API.refresh_access_token(refresh_token: user.strava_access_token)

    user.update!(
      strava_access_token: access_token.access_token,
      strava_access_token_expires_at: access_token.expires_at,
      strava_refresh_token: access_token.refresh_token
    )

    updated_user_count += 1
  end

  puts "[migrate_users_to_strava_refresh_tokens] Migrated #{updated_user_count} users to Strava refresh tokens"
end
