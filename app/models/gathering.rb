class Gathering < ActiveRecord::Base
  attr_accessible :description, :location, :name
  
  validates :name, :presence => true
  validates :description, :presence => true
end
