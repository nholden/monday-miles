# frozen_string_literal: true

class SessionsController < ApplicationController

  def destroy
    session[:current_user_id] = nil
    redirect_to root_path, notice: 'You have been logged out'
  end

end
