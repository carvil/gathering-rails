
module UseCases
  class GatheringUseCase < UseCase
    
    def create
      gathering = Gathering.new(request.atts)
      
      if gathering.save
        Response.new(:gathering => gathering)
      else
        Response.new(:gathering => gathering, :errors => gathering.errors)
      end
    end
    
    def update
      errors = {}
      begin
        gathering = Gathering.find(request.id)
        gathering.update_attributes(request.atts)
        
        if gathering.save
          Response.new(:gathering => gathering)
        else
          Response.new(:gathering => gathering, :errors => gathering.errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering => nil, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
    def show
      begin
        gathering = Gathering.find(request.id)
      rescue ActiveRecord::RecordNotFound => e
        errors = {:record_not_found => e.message}
      rescue => e
        errors = {:unknown_exception => e}
      end
      
      if gathering
        Response.new(:gathering => gathering)
      else
        Response.new(:gathering => nil, :errors => errors)
      end
    end
    
    def edit
      show
    end
    
    def list
      gatherings = Gathering.all
      Response.new(:gatherings => gatherings)
    end
    
    def new
      gathering = Gathering.new
      Response.new(:gathering => gathering)
    end
    
    def destroy
      begin
        gathering = Gathering.find(request.id)
        
        if gathering.destroy
          Response.new(:gathering => gathering)
        else
          errors.merge(gathering.errors)
          Response.new(:gathering => gathering, :errors => errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering => nil, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
  end
end