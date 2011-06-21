class UserMailer < ActionMailer::Base
  include ApplicationHelper

  def welcome_email(user)
    @project_name = get_project_name
    @user = user.username

    mail( :to => user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "Welcome to " + @project_name)

  end


  def event_email(user, event, host)
    @project_name = get_project_name
    @event = event
    @host = host
    logger.debug "event key " + @event.event_key
    # @host = request.env["HTTP_HOST"]
    
    # @event_title = event.title
    # @event_key = event.event_key 

    mail( :to => user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "You created " + @event.title + " at " + @project_name)

  end




end
