# == Schema Information
# Schema version: 20110613023256
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  event_id   :integer
#

class Group < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end
