# == Schema Information
# Schema version: 20110723054355
#
# Table name: places
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  description    :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  cid            :string(255)
#  address        :string(255)
#  neighborhood   :string(255)
#  rating         :string(255)
#  price          :string(255)
#  reference      :string(255)
#  url            :string(255)
#  comments       :text
#  external_links :text
#  image_links    :text
#

class Place < ActiveRecord::Base

  attr_accessible :name, :description, :cid, :address, :neighborhood, :rating, :price, :reference, :url, :comments, :external_links, :image_links

  #YAML hash for 'objects' - expected a list of links
  serialize :comments
  serialize :external_links
  serialize :image_links


  has_many :votes
  has_many :participants, :through => :votes

  has_many :schedules
  has_many :events, :through => :schedules

  validates :name, :presence => true

  default_scope :order => 'places.created_at DESC'

end
