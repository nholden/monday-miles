class MondayActivitiesController < ApplicationController

  expose(:user) { User.find_by_slug(params[:user_slug]) }
  expose(:year) { (params[:year] || Time.current.year).to_i }

  def show
    render json: user.monday_activities.in_year(year).decorate.map(&:vue_data).to_json
  end

end
