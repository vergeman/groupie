class UserMailer < ActionMailer::Base
  include ApplicationHelper
  include EventsHelper

  def welcome_email(user, host)
    @project_name = get_project_name
    @user = user
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


#via rake task
# bundle exec rake event_expiry_email
  def event_expiry_email(user, event, host, lead_place)
    @project_name = get_project_name
    @user = user
    @event = event
    @host = host
    @time = Time.new
    @lead_place = lead_place
  

    mail( :to => @user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "Let's #{@project_name} at #{@event.title}")

  end
  

end
