

task :event_expiry_email => :environment do
  include EventsHelper

  events = unexpired_events

  events.each do |e|

    puts "checking #{e.title}"

    next if Vote.where(:participant_id => e.participants).empty?

    if (e.event_date - get_expiry_hours(e) ) - Time.now < 0
      puts "found expired event: #{e.title}"

      @user = User.find(e.admin_id)
      @event = e
      # @host = "http://67.244.91.42:3001"
      @host = ENV['HTTP_HOST']
      @time = Time.new        
      @lead_place = Place.find(Vote.where(:participant_id => e.participants).group("place_id").sum("vote").sort_by{|k,v| v}.last[0]).name
    

      #send email
      puts "sending email"

      UserMailer.event_expiry_email(@user, @event, @host, @lead_place).deliver

      #tag as sent

      e.update_attributes(:sent_expiry_email => true)
      e.save!

    else
      puts "checked but not expired: #{e.title}"
    end

  end

  
end
