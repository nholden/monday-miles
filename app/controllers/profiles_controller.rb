class ProfilesController < ApplicationController

  expose(:user) { User.find_by_slug(params[:user_slug]).decorate }

  def show
  end

end
