class Gathering < ActiveRecord::Base
  attr_accessible :description, :location, :name, :scheduled_date
  
  has_many :events, :dependent => :destroy
  has_many :gathering_users, :dependent => :destroy
  has_many :users, :through => :gathering_users
  
  validates :name, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :scheduled_date, :presence => true
  
  def self.with_user(user_id)
    joins(:gathering_users).where(:gathering_users => {:user_id => user_id}).all
  end
end
