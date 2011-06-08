module ApplicationHelper

#title helper
#returns title

  def title
    base_title = "Groupie"
  
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end

  end


end
