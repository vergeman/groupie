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

  validates :admin_id, :presence => true;
#will probbaly need an association w/ admin_id as foreign_key for users

  #ordering of event by date
  default_scope :order => 'events.event_date DESC'
end
