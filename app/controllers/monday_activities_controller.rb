# frozen_string_literal: true

class MondayActivitiesController < ApplicationController

  expose(:user) { User.find_by_slug!(params[:user_slug]) }
  expose(:year) { (params[:year] || Time.current.year).to_i }

  def show
    activities = user.monday_activities.not_deleted.in_year(year)

    render json: activities.decorate.vue_data.merge(
      {
        mondays: Year.new(year).mondays_data(
          on_or_before_date: [Date.yesterday, activities.first.try(:local_start_date)].compact.max
        )
      }
    )
  end

end
