module ApplicationHelper

  #cookie event add
  def add_cookie_event
    if (user_signed_in? && cookies.signed[:event].present?)  #was set to present - may need to revert

      logger.debug "COOKIE IS #{cookies.signed[:event]}"

      event = cookies.signed[:event]
      Participant.create(:user_id => current_user.id,
                         :event_id => cookies.signed[:event],
                         :votes_remaining =>
                         Event.find(cookies.signed[:event]).starting_votes)

      cookies.delete :event

      redirect_to event_path(event)
    end
  end

  #project name
  def get_project_name
    "Get Together"
  end

  #title helper
  #returns title
  def title
    # @title defined in controller
    base_title = get_project_name
    
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end

  end

  #neighborhooods
  def get_neighborhoods
    neighborhoods = ["New York City",
                     "Brooklyn Heights", 
                     "Bushwick",
                     "Chelsea",
                     "Chinatown", 
                     "Dumbo",
                     "East Village",
                     "Financial District",
                     "Flatiron District",
                     "Gramercy",
                     "Greenpoint",
                     "Greenwich Village",
                     "Harlem",
                     "Little Italy",
                     "Lower East Side",
                     "Midtown East",
                     "Midtown West",
                     "Morningside Heights",
                     "Murray Hill",
                     "Nolita",
                     "Park Slope",
                     "SoHo",
                     "Times Square",
                     "Tribeca",
                     "Upper East Side",
                     "Upper West Side",
                     "West Village",
                     "Williamsburg"]                     
    
  end

end
