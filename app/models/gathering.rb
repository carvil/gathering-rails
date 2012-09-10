class Gathering < ActiveRecord::Base
  attr_accessible :description, :location, :name
  
  has_many :events, :dependent => :destroy
  
  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true
end
