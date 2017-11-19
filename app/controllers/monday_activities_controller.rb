class MondayActivitiesController < ApplicationController

  expose(:user) { User.find(params[:user_id]) }
  expose(:page) { params[:page] || 1 }

  def show
    render json: user.monday_activities.page(page).decorate.map(&:vue_data).to_json
  end

end
