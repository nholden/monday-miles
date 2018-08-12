task :update_user_activities => :environment do
  User.not_archived.select(:id, :last_signed_in_at).each do |user|
    start_time_string = user.last_signed_in_at.try(:iso8601)
    puts "[update_user_activities] Fetching activities for User #{user.id} since #{start_time_string.presence || 'the beginning' }."
    StravaActivitiesInTimeRangeWorker.perform_async(user.id, start_time_string, Time.current.iso8601)
  end
end

task :archive_stale_users => :environment do
  StaleUserArchiverWorker.perform_async
end
