class Activity < ApplicationRecord

  belongs_to :user

  scope :monday, -> { where(monday: true).order(start_time: :desc) }
  scope :ytd_monday, -> { monday.where('start_time >= ?', Time.current.beginning_of_year) }

  paginates_per 5

end
