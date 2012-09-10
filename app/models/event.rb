class Event < ActiveRecord::Base
  attr_accessible :title, :description, :scheduled_date, :cancelled_at, :location
  belongs_to :gathering
  
  validates :title, :presence => true
  validates :description, :presence => true
  validates :scheduled_date, :presence => true
  validates :location, :presence => true
  validates :gathering, :presence => true, :associated => true
  
  validates :title, :uniqueness => {:scope => :gathering_id, :message => "events on the same gathering should have different titles"}
end
