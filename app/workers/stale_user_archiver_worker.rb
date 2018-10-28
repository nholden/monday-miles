# frozen_string_literal: true

class StaleUserArchiverWorker

  include Sidekiq::Worker

  def perform
    user_ids = User.not_archived.stale.pluck(:id)
    User.where(id: user_ids).update_all archived_at: Time.current
    Activity.where(user_id: user_ids).delete_all
  end

end
