class EventUser < ActiveRecord::Base
  attr_accessible :event_id, :user_id, :inactive_at
  belongs_to :user
  belongs_to :event
end
