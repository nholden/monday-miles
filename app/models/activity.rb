class Activity < ApplicationRecord

  belongs_to :user

  scope :monday, -> { where(monday: true).order(start_time: :desc) }
  scope :in_year, -> (year) { where(start_time: Date.new(year)...Date.new(year + 1)) }

  def local_start_date
    (start_time + utc_offset.minutes).to_date
  end

end
