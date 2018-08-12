class ProfilesController < ApplicationController

  expose!(:user) { User.not_archived.find_by_slug!(params[:user_slug]).decorate }

  def show
  end

end
