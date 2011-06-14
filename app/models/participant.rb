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
  attr_accessible :user_id, :event_id, :votes_remaining
      #seems we need to keep foreign keys accessible for associations to work

  belongs_to :user
  belongs_to :event

end
