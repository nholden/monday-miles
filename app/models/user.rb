class User < ApplicationRecord

  has_many :activities
  has_many :monday_activities, -> { monday }, class_name: 'Activity'

  delegate :length, :started, :ended,
    to: :recent_monday_streak, prefix: true

  def recent_monday_streak
    monday_streaks.recent
  end

  private

  def monday_streaks
    MondayStreaks.new(monday_activities.pluck(:start_time).map(&:to_date))
  end

end
