class Ability
  include CanCan::Ability

  def initialize(user)
    # setup action to do everything but delete
    alias_action :read, :create, :update, :to => :manage_no_destroy
    
    user ||= User.new # guest user if not logged in
    
    if !user.is_active? || user.id.nil?
      #cannot do anything if the user is inactive (should never get this far but better safe than sorry...)
    elsif user.is_admin?
      can :manage, :all
    else
      # Gatherings
        # anyone can create a new gathering
        can :create, Gathering
        
        # readers can read both gatherings and events
        can :read, Gathering do |gathering|
          gu = GatheringUser.find_by_gathering_and_user(gathering.id, user.id)
          gu && gu.is_reader?
        end
        # contributors can do everything except destroy gatherings, and can manage events
        can :manage_no_destroy, Gathering do |gathering|
          gu = GatheringUser.find_by_gathering_and_user(gathering.id, user.id)
          gu && gu.is_contributor?
        end
        # owners can manage both the gathering and the events
        can :manage, Gathering do |gathering|
          gu = GatheringUser.find_by_gathering_and_user(gathering.id, user.id)
          gu && gu.is_owner?
        end
        
      # GatheringUsers
        # anyone can create a new gathering user if none are already associated to a gathering (This is to allow people to create themselves as owners automatically when first creating a gathering)
        can :create, GatheringUser do |gathering_user|
          GatheringUser.with_gathering(gathering_user.gathering_id).all.size == 0
        end
        can :read, GatheringUser do |gathering_user|
          gu = GatheringUser.find_by_gathering_and_user(gathering_user.gathering_id, user.id)
          gu && (gu.is_contributor? || gu.id == gathering_user.id)
        end
        can :manage, GatheringUser do |gathering_user|
          gu = GatheringUser.find_by_gathering_and_user(gathering_user.gathering_id, user.id)
          gu && gu.is_owner?
        end
        
      # Events
        # TODO: Only allow users that are owners or contributors of at least one gathering make new events
        can :new, Event
        can :read, Event do |event|
          gu = GatheringUser.find_by_gathering_and_user(event.gathering_id, user.id)
          gu && gu.is_reader?
        end
        can :manage, Event do |event|
          gu = GatheringUser.find_by_gathering_and_user(event.gathering_id, user.id)
          gu && (gu.is_owner? || gu.is_contributor?)
        end
    end
  end
end
