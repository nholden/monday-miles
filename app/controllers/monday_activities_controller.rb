class MondayActivitiesController < ApplicationController

  expose(:user) { User.find_by_slug!(params[:user_slug]) }
  expose(:year) { (params[:year] || Time.current.year).to_i }

  def show
    render json: user.monday_activities.in_year(year).decorate.vue_data.merge(
      { mondays: Year.new(year).mondays_data }
    )
  end

end
