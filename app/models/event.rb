class Event < ActiveRecord::Base
  belongs_to :gathering
  attr_accessible :title, :description, :scheduled_date, :cancelled_at, :location, :gathering
  
  validates :title, :presence => true
  validates :description, :presence => true
  validates :scheduled_date, :presence => true
  validates :location, :presence => true
  validates :gathering_id, :presence => true
  validates :gathering, :associated => true
  
  validates :title, :uniqueness => {:scope => :gathering_id, :message => "events on the same gathering should have different titles"}
  
  # instance methods
  def is_cancelled?
    !cancelled_at.nil?
  end
end