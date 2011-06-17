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

  validates :name, :presence => true

  default_scope :order => 'places.created_at DESC'
end
