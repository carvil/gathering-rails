class GatheringUser < ActiveRecord::Base
  attr_accessible :gathering_id, :inactive_at, :user_id, :role, :gathering, :user
  
  belongs_to :user
  belongs_to :gathering
  
  validates :user, :associated => true
  validates :gathering, :associated => true
  
  validates :user_id, :presence => true
  validates :gathering_id, :presence => true
  validates :role, :presence => true
  
  validates :gathering_id, :uniqueness => {:scope => :user_id, :message => "You should not have multiple roles for the same gathering user"}
  
  # helper class methods
  class << self
    def active
      where(:inactive_at => nil)
    end
    def with_gathering(gathering_id)
      where(:gathering_id => gathering_id)
    end
    def with_user(user_id)
      where(:user_id => user_id)
    end
    def owners
      with_role(:owner)
    end
  end
    
  # ROLE_LIST must be set before the Roles module is included, otherwise your custom roles WILL NOT be used to create helper methods 
  # (and the default helper methods will still exist to potentially mess you up)
  ROLE_LIST = %w[owner contributor reader]
  
  include Roles
  
  # if the instance is an owner and there is only one owner for the gathering then the instance is a "single owner" and cannot be deleted or changed to a new role
  def single_owner?
    # TODO: Kinda breaking law of demeter here
    is_owner? && self.gathering.gathering_users.owners.size == 1
  end
  
  def is_active?
    inactive_at.nil?
  end
  
end
