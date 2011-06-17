# == Schema Information
# Schema version: 20110617041720
#
# Table name: votes
#
#  id             :integer         not null, primary key
#  participant_id :integer
#  place_id       :integer
#  vote           :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Vote < ActiveRecord::Base
end
