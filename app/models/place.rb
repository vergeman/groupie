# == Schema Information
# Schema version: 20110617034805
#
# Table name: places
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Place < ActiveRecord::Base

  attr_accessible :name, :description

  has_many :votes
  has_many :participants, :through => :votes

  has_many :schedules
  has_many :events, :through => :schedules

  validates :name, :presence => true

  default_scope :order => 'places.created_at DESC'
end
