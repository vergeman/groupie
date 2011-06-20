class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @title = 'Home'

    # @user = User.find(params[:id])
    @user = User.find(current_user.id)
    @events = @user.events
    # @participants = @user.participants
    # @user = User.find_by_username(params[:id])
  end





end
