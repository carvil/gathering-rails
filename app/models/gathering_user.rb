class GatheringUser < ActiveRecord::Base
  attr_accessible :gathering_id, :inactive_at, :user_id
  belongs_to :user
  belongs_to :gathering
end
