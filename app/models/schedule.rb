class Schedule < ActiveRecord::Base

  attr_accessible :event_id, :place_id

  belongs_to :place
  belongs_to :event

  validates :place_id, :presence => true
  validates :event_id, :presence => true


end
