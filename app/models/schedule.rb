# == Schema Information
# Schema version: 20110723054355
#
# Table name: schedules
#
#  id         :integer         not null, primary key
#  event_id   :integer
#  place_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  admin_id   :integer
#

class Schedule < ActiveRecord::Base

  attr_accessible :event_id, :place_id, :admin_id

  belongs_to :place
  belongs_to :event

  validates :place_id, :presence => true
  validates :event_id, :presence => true

  validates_uniqueness_of :place_id, :scope => :event_id, :message => "only have one unique place associated w/ event"

end
