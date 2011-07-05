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

  attr_accessible :participant_id, :place_id, :vote

  belongs_to :participant
  belongs_to :place

  validates :participant_id, :presence => true;
  validates :place_id, :presence => true;

  validates_uniqueness_of :participant_id, :scope => :place_id, :message => "only have one participant vote per place"
end

