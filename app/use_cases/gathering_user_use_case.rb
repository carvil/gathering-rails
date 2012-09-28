
module UseCases
  class GatheringUserUseCase < UseCase
    def create
      begin
        # Catch the gathering value passed in as an ID and convert it to a Gathering object
        if [String, Fixnum].include? request.atts[:gathering].class
          request.atts[:gathering] = Gathering.find(request.atts[:gathering].to_i) if request.atts[:gathering].class == String
          request.atts[:gathering] = Gathering.find(request.atts[:gathering]) if request.atts[:gathering].class == Fixnum
        end
        if [String, Fixnum].include? request.atts[:user].class
          request.atts[:user] = User.find(request.atts[:user].to_i) if request.atts[:user].class == String
          request.atts[:user] = User.find(request.atts[:user]) if request.atts[:user].class == Fixnum
        end
        
        gathering_user = GatheringUser.new
        gathering_user.gathering = request.atts[:gathering]
        gathering_user.user = request.atts[:user]
        gathering_user.role = request.atts[:role]
        gathering_user.inactive_at = request.atts[:inactive_at]
        
        if request.ability.cannot? :create, gathering_user
          add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
        elsif !gathering_user.save
          add_class_errors_hash(gathering_user.class, gathering_user.errors.messages, self_class_symbol, __method__)
        end
        
        respond_with(:gathering_user => gathering_user)
      rescue ActiveRecord::RecordNotFound => e
        item = (e.message.include?("Gathering") ? :gathering : :user)
        add_error(:record_not_found, self_class_symbol, __method__, item, "The specified #{item} was not found.")
        respond_with(:gathering_user => gathering_user)
      end 
    end
    
    def update
      begin
        gathering_user = GatheringUser.find(request.id)
        
        if request.ability.cannot? :update, gathering_user
          add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
        # Cannot update the last owner to anything other than owner
        elsif request.atts[:role] != gathering_user.role && gathering_user.single_owner?
          add_error(:unable_to_remove_last_owner, self_class_symbol, __method__, :gathering_user, "Removing the last owner of a gathering is not permitted.  Create a new owner first and try again.")
        elsif !gathering_user.update_attributes(request.atts)
          add_class_errors_hash(gathering_user.class, gathering_user.errors.messages, self_class_symbol, __method__)
        end
        
        respond_with(:gathering_user => gathering_user)
        
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, item, "The specified #{item} was not found.")
        respond_with(:gathering_user => gathering_user)
      end
    end
    
    def show
      begin
        gathering_user = GatheringUser.find(request.id)
        if request.ability.cannot? :read, gathering_user
          add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
          gathering_user = nil
        end
        
        respond_with(:gathering_user => gathering_user)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering_user, e.message)
        respond_with(:gathering_user => nil)
      end
    end
    
    def edit
      begin
        gathering_user = GatheringUser.find(request.id)
        if request.ability.cannot? :edit, gathering_user
          add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
          gathering_user = nil
        end
        
        respond_with(:gathering_user => gathering_user)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering_user, e.message)
        respond_with(:gathering_user => nil)
      end
    end
    
    def list
      gathering_users = []
      if !request.user
        add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
      else
        if request.gathering_id
          query = GatheringUser.with_gathering(request.gathering_id)
        else
          query = GatheringUser.with_user(request.user.id)
        end 
        
        # TODO: Figure out a way to do authorize a collection more efficiently than looping through each one
        query.all.each do |gathering_user|
          gathering_users << gathering_user if request.ability.can? :read, gathering_user
        end
      end
      
      respond_with(:gathering_users => gathering_users)
    end
    
    def new
      gathering_user = GatheringUser.new
      if request.ability.cannot? :create, gathering_user
        gathering_user = nil
        add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
      end
      respond_with(:gathering_user => gathering_user)
    end
    
    def destroy
      begin
        gathering_user = GatheringUser.find(request.id)
        
        if gathering_user.single_owner?
          add_error(:unable_to_destroy_last_owner, self_class_symbol, __method__, :gathering_user, "Unable to destroy the only owner of a gathering, please make a new owner before attempting to delete the requested owner.")
        elsif request.ability.cannot? :destroy, gathering_user
          add_error(:access_denied, self_class_symbol, __method__, :gathering_user, access_denied_message(__method__))
        elsif !gathering_user.destroy
          add_class_errors_hash(gathering_user.class, gathering_user.errors.messages, self_class_symbol, :destroy)
        end
        
        # Verify whether we should return the gathering user if found
        gathering_user = nil if request.ability.cannot? :read, gathering_user
        
        respond_with(:gathering_user => gathering_user)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering_user, e.message)
        respond_with(:gathering_user => nil)
      end
    end
    
    private
    def access_denied_message(action)
      "Requesting user does not have sufficient permission to #{action.to_s} a Gathering User"
    end
  end
end