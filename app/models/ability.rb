class Ability
  include CanCan::Ability

  def initialize(user)
    # setup action to do everything but delete
    alias_action :index, :show, :edit, :update, :new, :create, :to => :manage_no_destroy
    
    user ||= User.new # guest user if not logged in
    
    if !user.is_active?
      #cannot do anything if the user is inactive (should never get this far but better safe than sorry...)
    elsif user.is_admin?
      can :manage, :all
    else
      # Gatherings & Events
      # anyone can create a new gathering
      can :create, Gathering
      
      # readers can read both gatherings and events
      can :read, Gathering do |gathering|
        #TODO: create custom finder method
        gathering_user = GatheringUser.active.with_gathering(gathering.id).with_user(user.id).all.first
        can :read, Event
        gathering_user.is_reader?
      end
      
      # contributors can do everything except destroy gatherings, and can manage events
      can :manage_no_destroy do |gathering|
        gathering_user = GatheringUser.active.with_gathering(gathering.id).with_user(user.id).all.first
        can :manage, Event
        gathering_user.is_contributor?
      end
      
      # owners can manage both the gathering and the events
      can :manage, Gathering do |gathering|
        gathering_user = GatheringUser.with_gathering(gathering.id).with_user(user.id).all.first
        can :manage, Event
        gathering_user.is_owner?
      end
      
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
