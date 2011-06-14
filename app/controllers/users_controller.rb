class UsersController < ApplicationController

  def show
    @title = 'Home'

    @user = User.find(params[:id])
    @events = @user.participants
    # @user = User.find_by_username(params[:id])
  end



end
