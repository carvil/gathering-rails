
module UseCases
  class EventUseCase < UseCase
    
    def create
      begin
        # Catch the gathering value passed in as an ID and convert it to a Gathering object
        if [String, Fixnum].include? request.atts[:gathering].class
          request.atts[:gathering] = Gathering.find(request.atts[:gathering].to_i) if request.atts[:gathering].class == String
          request.atts[:gathering] = Gathering.find(request.atts[:gathering]) if request.atts[:gathering].class == Fixnum
        end
        atts = request.atts.dup
        gathering = atts.delete(:gathering)
        event = Event.new(atts)
        event.gathering = gathering
        
        if request.ability.cannot? :create, event
          add_error(:access_denied, self_class_symbol, __method__, :event, access_denied_message(__method__))
        elsif !event.save
          add_class_errors_hash(event.class, event.errors.messages, self_class_symbol, __method__)
        end
        
        respond_with(:event => event)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering, e.message)
        respond_with(:event => nil)
      end 
    end
    
    def update
      begin
        event = Event.find(request.id)
        
        # Catch the cancelled_at attribute and convert any non-zero/false/nil value into the current time
        if !event.is_cancelled? && !request.atts[:cancelled_at].nil? && ![0, false].include?(request.atts[:cancelled_at])
          request.atts[:cancelled_at] = Time.new
        else
          request.atts[:cancelled_at] = nil
        end
        
        # Catch the gathering value passed in as an ID and convert it to a Gathering object
        request.atts.delete(:gathering)
             
        if request.ability.cannot? :update, event
          add_error(:access_denied, self_class_symbol, __method__, :event, access_denied_message(__method__))
        elsif !event.update_attributes(request.atts)
          add_class_errors_hash(event.class, event.errors.messages, self_class_symbol, __method__)
        end
        
        respond_with(:event => event)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :event, e.message)
        respond_with(:event => nil)
      end
    end
    
    def show
      begin
        event = Event.find(request.id)
        
        if request.ability.cannot? :read, event
          add_error(:access_denied, self_class_symbol, __method__, :event, access_denied_message(__method__))
        end
        
        respond_with(:event => event)
        
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :event,  e.message)
        respond_with(:event => nil)
      end
    end
    
    def edit
      begin
        event = Event.find(request.id)
        
        if request.ability.cannot? :edit, event
          add_error(:access_denied, self_class_symbol, __method__, :event, access_denied_message(__method__))
        end
        
        respond_with(:event => event)
        
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :event,  e.message)
        respond_with(:event => nil)
      end
    end
    
    def list
      events = [] 
      
      Event.with_user(request.user.id).all.each do |event|
        events << event if request.ability.can? :index, event
      end
      
      respond_with(:events => events)
    end
    
    def list_by_gathering
      events = []
      gathering_id = request.gathering_id || request.gathering.id
      gathering = request.gathering || Gathering.find(gathering_id)
      
      Event.with_user(request.user.id).where(:gathering_id => gathering_id).all.each do |event|
        events << event if request.ability.can? :index, event
      end
      
      respond_with(:events => events, :gathering => gathering)
    end
    
    def new
      begin
        event = Event.new
        # TODO: Restrict this list to only those gatherings the requesting user can create events against
        gatherings = Gathering.with_user(request.user.id)
        
        if request.gathering || request.gathering_id
          event.gathering = Gathering.find(request.gathering_id || request.gathering.id)
        end
        
        if request.ability.cannot? :new, event
          add_error(:access_denied, self_class_symbol, __method__, :event, access_denied_message(__method__))
          event = nil
        end
        
        respond_with(:event => event, :gatherings => gatherings)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering, e.message)
        respond_with(:event => nil)
      end
    end
    
    def destroy
      begin
        event = Event.find(request.id)
        
        if request.ability.cannot? :destroy, event
          add_error(:access_denied, self_class_symbol, __method__, :event, access_denied_message(__method__))
        elsif !event.save 
          add_class_errors_hash(event.class, event.errors.messages, self_class_symbol, __method__)
        end
        
        respond_with(:event => event)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :event, e.message)
        respond_with(:event => nil)
      end
    end
   
    private
    def access_denied_message(action)
      "Requesting user does not have sufficient permission to #{action.to_s} a Gathering"
    end 
  end
end