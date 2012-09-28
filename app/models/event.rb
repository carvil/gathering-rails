class Event < ActiveRecord::Base
  belongs_to :gathering
  has_many :gathering_users, :through => :gathering
  attr_accessible :title, :description, :scheduled_date, :cancelled_at, :location
  attr_protected :gathering, :gathering_id
  
  validates :title, :presence => true
  validates :description, :presence => true
  validates :scheduled_date, :presence => true
  validates :location, :presence => true
  validates :gathering_id, :presence => true
  validates :gathering, :associated => true
  
  validates :title, :uniqueness => {:scope => :gathering_id, :message => "events for the same gathering should have different titles"}
  
  # instance methods
  def is_cancelled?
    !cancelled_at.nil?
  end
  
  def self.with_user(user_id)
    joins(:gathering_users).where(:gathering_users => {:user_id => user_id})
  end
end
