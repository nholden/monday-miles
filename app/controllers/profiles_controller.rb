class ProfilesController < ApplicationController

  expose(:user) { User.find(params[:user_id]).decorate }

  def show
  end

end
