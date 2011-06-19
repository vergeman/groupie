class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    @user = User.find(current_user.id)
    @events = @user.events

    #keep last as it returns the user path
    user_path(:id => current_user)
  end

end
