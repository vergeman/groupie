class Schedule < ActiveRecord::Base

  attr_accessible :event_id, :place_id

  belongs_to :place
  belongs_to :event


end
