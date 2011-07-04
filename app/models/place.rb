# == Schema Information
# Schema version: 20110704052049
#
# Table name: places
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  description    :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  cid            :integer
#  address        :string(255)
#  neighborhood   :string(255)
#  rating         :string(255)
#  price          :string(255)
#  comments       :text
#  external_links :text
#  image_links    :text
#

class Place < ActiveRecord::Base

  attr_accessible :name, :description, :cid, :address, :neighborhood, :rating, :price, :comments, :external_links, :image_links

  serialize :comments, :external_links, :image_links #YAML hash for 'objects' - expected a list of links


  has_many :votes
  has_many :participants, :through => :votes

  has_many :schedules
  has_many :events, :through => :schedules

  validates :name, :presence => true

  default_scope :order => 'places.created_at DESC'
end
