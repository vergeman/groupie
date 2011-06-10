module ApplicationHelper

#title helper
#returns title

  def title
    # @title defined in controller
    base_title = "Get Together"
  
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end

  end


end
