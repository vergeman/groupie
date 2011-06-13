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
  attr_accessible #want no attributes to be accessible to mass assignment

  belongs_to :user
  belongs_to :event
end
