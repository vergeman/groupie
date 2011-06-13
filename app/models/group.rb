# == Schema Information
# Schema version: 20110613013109
#
# Table name: groups
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Group < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
end
