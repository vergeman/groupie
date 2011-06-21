class RegistrationsController < Devise::RegistrationsController
  helper_method :cookies

def new
  super
end


def create
  #event_add
  #if cookies[:event]
    #add event
  #  event_add = cookies[:event]
  #end

  super
end

end
