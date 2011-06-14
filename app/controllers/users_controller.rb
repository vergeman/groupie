class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # @user = User.find_by_username(params[:id])
  end

end
