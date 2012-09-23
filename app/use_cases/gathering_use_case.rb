
module UseCases
  class GatheringUseCase < UseCase
    def create
      begin
        # By default we create a GatheringUser as owner whenever a new gathering is created
        gathering = Gathering.new(request.atts)
        user = request.user
        role = :owner
      
        if user.persisted? && gathering.save
          response = GatheringUserUseCase.new(:atts => {:gathering => gathering, :user => user, :role => role}).create
          if response.ok?
            Response.new(:gathering => gathering)
          else
            gathering.destroy
            Response.new(:gathering => gathering, :errors => response.gathering_user.errors)
          end
        else
          Response.new(:gathering => gathering, :errors => gathering.errors)
        end
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering => gathering, :errors => {:record_not_found => e.message})
      rescue Exception => e
        Response.new(:errors => {:unknown_exception => e})
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
        request.ability.authorize! :destroy, gathering
        
        if gathering.destroy
          Response.new(:gathering => gathering)
        else
          errors.merge(gathering.errors)
          Response.new(:gathering => gathering, :errors => errors)
        end
      rescue CanCan::AccessDenied => e
        Response.new(:gathering => gathering, :errors => {:access_denied => e.message}) #TODO: create a small module for handling error messages
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering => nil, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
  end
end