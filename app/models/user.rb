class User < ApplicationRecord

  has_many :activities
  has_many :monday_activities, -> { monday }, class_name: 'Activity'
  has_many :ytd_monday_activities, -> { ytd_monday }, class_name: 'Activity'

  delegate :current_length, to: :monday_streak, prefix: true

  def monday_streak
    MondayStreak.new(monday_activities.pluck(:start_time).map(&:to_date))
  end

end
