task :refresh_active_users => :environment do
  ActiveUserRefreshWorker.perform_async
end

task :archive_stale_users => :environment do
  StaleUserArchiverWorker.perform_async
end
