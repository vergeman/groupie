module EventsHelper
end

# returns hours before event expiry that polls will close
def get_expiry_hours(event)
  
  hours_left =  (event.event_date - event.created_at) / 60 / 60
  
  if hours_left >= 36
    return 24.hours
  elsif hours_left < 24
    return 5.hours
  end

  return 12.hours

end


def unexpired_events
  Event.where(:sent_expiry_email => false)    
end
