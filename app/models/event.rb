# == Schema Information
# Schema version: 20110613002301
#
# Table name: events
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  title       :string(255)
#  description :string(255)
#  event_date  :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
end
