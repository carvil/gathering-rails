
module UseCases
  class EventUseCase < UseCase
    
    def create
      begin
        # Catch the gathering value passed in as an ID and convert it to a Gathering object
        if [String, Fixnum].include? request.atts[:gathering].class
          request.atts[:gathering] = Gathering.find(request.atts[:gathering].to_i) if request.atts[:gathering].class == String
          request.atts[:gathering] = Gathering.find(request.atts[:gathering]) if request.atts[:gathering].class == Fixnum
        end
        event = Event.new(request.atts)
        
        if event.save
          Response.new(:event => event)
        else
          Response.new(:event => event, :errors => event.errors)
        end
      rescue Exception => e
        Response.new(:event => nil, :errors => {:exception => e.message})
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
        if [String, Fixnum].include? request.atts[:gathering].class
          request.atts[:gathering] = Gathering.find(request.atts[:gathering].to_i) if request.atts[:gathering].class == String
          request.atts[:gathering] = Gathering.find(request.atts[:gathering]) if request.atts[:gathering].class == Fixnum
        end
             
        event.update_attributes(request.atts)
        
        if event.save
          Response.new(:event => event)
        else
          Response.new(:event => event, :errors => event.errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:event => nil, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
    def show
      begin
        event = Event.find(request.id)
      rescue ActiveRecord::RecordNotFound => e
        errors = {:record_not_found => e.message}
      rescue => e
        errors = {:unknown_exception => e}
      end
      
      if event
        Response.new(:event => event)
      else
        Response.new(:event => nil, :errors => errors)
      end
    end
    
    def edit
      begin
        event = Event.find(request.id)
      rescue ActiveRecord::RecordNotFound => e
        errors = {:record_not_found => e.message}
      rescue => e
        errors = {:unknown_exception => e}
      end
      
      if event
        Response.new(:event => event, :gatherings => Gathering.all)
      else
        Response.new(:event => nil, :gatherings => Gathering.all, :errors => errors)
      end
    end
    
    def list
      events = Event.all
      Response.new(:events => events)
    end
    
    def list_by_gathering
      gathering_id = request.gathering_id || request.gathering.id
      gathering = request.gathering ? request.gathering : Gathering.find(gathering_id)
      events = Event.where(:gathering_id => gathering_id)
      Response.new(:events => events, :gathering => gathering)
    end
    
    def new
      event = Event.new
      if request.gathering or request.gathering_id
        event.gathering = Gathering.find(request.gathering_id || request.gathering.id)
      end
      Response.new(:event => event, :gatherings => Gathering.all)
    end
    
    def destroy
      begin
        event = Event.find(request.id)
        
        if event.destroy
          Response.new(:event => event)
        else
          errors.merge(event.errors)
          Response.new(:event => event, :errors => errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:event => nil, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
  end
end