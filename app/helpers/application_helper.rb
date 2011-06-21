module ApplicationHelper

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


end
