
module UseCases
  class EventUseCase < UseCase
    
    def create
      event = Event.new(request.atts)
      event.gathering = request.gathering
      
      if event.save
        Response.new(:event => event)
      else
        Response.new(:event => event, :errors => event.errors)
      end
    end
    
    def update
      errors = {}
      begin
        event = Event.find(request.id)
        event.update_attributes(request.atts)
        
        if event.save
          Response.new(:event => event)
        else
          Response.new(:event => event, :errors => event.errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:event => nil, errors => {:record_not_found => e.message})
      rescue => e
        Response.new(errors = {:unknown_exception => e})
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
      show
    end
    
    def list
      events = Event.all
      Response.new(:events => events)
    end
    
    def list_by_gathering
      events = Event.where(:gathering_id => request.gathering.id)
      Response.new(:events => events)
    end
    
    def new
      event = Event.new
      Response.new(:event => event)
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
        Response.new(:event => nil, errors => {:record_not_found => e.message})
      rescue => e
        Response.new(errors => {:unknown_exception => e})
      end
    end
    
  end
end