
module UseCases
  class GatheringUseCase < UseCase
    def create
      begin
        gathering = Gathering.new(request.atts)
        # By default we create a GatheringUser as owner whenever a new gathering is created
        user = request.user
        role = :owner
        
        # This conditional walks through each step and if it encounters an error will add that to the error list
        if !user.persisted?
          add_error(:record_not_found, :gathering_use_case, :create, :user, :message => "User specified does not currently exist.  Either it was never created or has been removed.")
        else
          if gathering.save
            response = GatheringUserUseCase.new(:gathering => gathering, :user => user, :role => role).create
            if !response.ok?
              # If the gathering user wasn't created we MUST destroy the gathering or or it will be orphaned.  This should never happen but better safe than sorry.
              gathering.destroy
              
              # Add the overall error from the perspective of the gathering
              add_error(:gathering_user, :gathering_use_case, :create, :gathering_user, :message => "Unable to create a GatheringUser, the gathering was not saved.")
              
              # Add the gathering_user use case errors as well
              add_errors(response.errors)
            end
          else
            add_active_record_errors(gathering.errors)
          end
        end
        
        # If we didn't trigger an exception then we respond here
        respond_with(:gathering => gathering)
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering => gathering, :errors => {:record_not_found => e.message})
      end
    end
    
    def update
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
      #rescue => e
      #  Response.new(:errors => {:unknown_exception => e})
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
        
        
        if request.ability.cannot? :destroy, gathering
          add_error(:access_denied, :gathering_use_case, :destroy, :gathering, "User does not have permission to destroy the specified gathering.")
          respond_with(:gathering => nil)
        elsif gathering.destroy
          respond_with(:gathering => gathering)
        else
          add_class_errors_hash(gathering.class, gathering.errors.messages, :gathering_use_case, :destroy)
          respond_with(:gathering => gathering)
        end
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, :gathering_use_case, :destroy, :gathering, "Gathering with id of #{request.id} could not be found.")
        respond_with(:gathering => nil)
      end
    end
    
  end
end