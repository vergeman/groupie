class UserMailer < ActionMailer::Base
  include ApplicationHelper

  def welcome_email(user)
    @project_name = get_project_name
    @user = user.username

    mail( :to => user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "Welcome to " + @project_name)

  end


  def event_email(user, title)
    @project_name = get_project_name
    @event_title = title

    mail( :to => user.email,
          :from => "no-reply@" + @project_name.gsub(/\s+/,"") + ".com",
          :subject => "You created " + @event_title + " at " + @project_name)

  end




end
