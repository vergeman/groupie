class UserMailer < ActionMailer::Base
  include ApplicationHelper

  def welcome_email(user, host)
    @project_name = get_project_name
    @user = user.username
    @host = host


    mail( :to => user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "Welcome to " + @project_name + "!")

  end


  def event_email(user, event, host)
    @project_name = get_project_name
    @user = user
    @event = event
    @host = host
    @time = Time.new

    logger.debug "event key " + @event.event_key

    mail( :to => user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "*You've Created a " + @project_name + "* " + @event.title)

  end




end
