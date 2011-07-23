# == Schema Information
# Schema version: 20110613220748
#
# Table name: participants
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  event_id        :integer
#  votes_remaining :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Participant < ActiveRecord::Base
  before_create :set_votes
  
  attr_accessible :user_id, :event_id, :votes_remaining
  #seems we need to keep foreign keys accessible for associations to work

  belongs_to :user
  belongs_to :event

  has_many :votes
  has_many :places, :through => :votes

  validates :user_id, :presence => true
  validates :event_id, :presence => true

  validates_uniqueness_of :user_id, :scope => :event_id, :message => "only have have one association with event"
  #validates :votes_remaining, :presence => true


  def set_votes
    self.votes_remaining = Event.find(self.event_id).starting_votes
  end

end
