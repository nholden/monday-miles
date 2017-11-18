class User < ApplicationRecord

  has_many :activities
  has_many :monday_activities, -> { monday }, class_name: 'Activity'
  has_many :ytd_monday_activities, -> { ytd_monday }, class_name: 'Activity'

end
