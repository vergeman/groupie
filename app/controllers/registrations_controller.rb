class RegistrationsController < Devise::RegistrationsController
  helper_method :cookies

def new

  super

end

def edit
  @user = current_user
  @events = @user.events

end


def create

  @host = request.env["HTTP_HOST"]
  @user = params[:user]

  super

  #on success send welcome_email
  if resource.save && User.find_by_username(@user.username)
    send_welcome_email(@user, @host)
  end

end



private 
def send_welcome_email(user, host)
  UserMailer.welcome_email(user, host).deliver
end


end
