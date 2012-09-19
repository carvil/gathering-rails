class GatheringUser < ActiveRecord::Base
  attr_accessible :gathering_id, :inactive_at, :user_id
  belongs_to :user
  belongs_to :gathering
  
  validates :user_id, :presence => true
  validates :gathering_id, :presence => true
  validates :role, :presence => true
  
  validates :user, :associated => true
  validates :gathering, :associated => true
  
  # ROLE_LIST must be set before the Roles module is included, otherwise your custom roles WILL NOT be used to create helper methods 
  # (and the default helper methods will still exist to potentially mess you up)
  # ROLE_LIST = %w[owner contributor reader]
  include Roles
  
end
