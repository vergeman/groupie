# == Schema Information
# Schema version: 20110613220748
#
# Table name: events
#
#  id             :integer         not null, primary key
#  admin_id       :integer
#  title          :string(255)
#  description    :string(255)
#  event_date     :datetime
#  starting_votes :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Event < ActiveRecord::Base

  attr_accessible :title, :description, :event_date, :starting_votes

  has_many :participants
  has_many :users, :through => :participants
end
