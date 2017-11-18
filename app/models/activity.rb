class Activity < ApplicationRecord

  belongs_to :user

  scope :monday, -> { where(monday: true) }
  scope :ytd_monday, -> { monday.where('start_time >= ?', Time.current.beginning_of_year) }

end
