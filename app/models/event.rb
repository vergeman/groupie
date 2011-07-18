# == Schema Information
# Schema version: 20110718005434
#
# Table name: events
#
#  id                :integer         not null, primary key
#  admin_id          :integer
#  title             :string(255)
#  description       :string(255)
#  event_date        :datetime
#  starting_votes    :integer
#  created_at        :datetime
#  updated_at        :datetime
#  event_key         :string(255)
#  sent_expiry_email :boolean
#

class Event < ActiveRecord::Base
  after_initialize :default_values

  attr_accessible :admin_id, :title, :description, :event_date, 
  :starting_votes, :event_key, :sent_expiry_email

  has_many :participants
  has_many :users, :through => :participants

  has_many :schedules
  has_many :places, :through => :schedules

  validates :title, :presence => true;
  validates :admin_id, :presence => true;
#will probbaly need an association w/ admin_id as foreign_key for users

  #ordering of event by date
  default_scope :order => 'events.event_date ASC'


private

  def default_values
    self.sent_expiry_email = false
  end

end
