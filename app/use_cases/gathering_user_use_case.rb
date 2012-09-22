
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
        gathering_user = GatheringUser.new(request.atts)
      
        if gathering_user.save
          Response.new(:gathering_user => gathering_user)
        else
          Response.new(:gathering_user => gathering_user, :errors => gathering_user.errors)
        end
      rescue Exception => e
        Response.new(:gathering_user => gathering_user, :errors => {:exception => e.message})
      end 
    end
    
    def update
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
        gathering_user = GatheringUser.find(request.id)
        gathering_user.update_attributes(request.atts)
        
        if gathering_user.save
          Response.new(:gathering_user => gathering_user)
        else
          Response.new(:gathering_user => gathering_user, :errors => gathering_user.errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering_user => gathering_user, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
    def show
      begin
        gathering_user = GatheringUser.find(request.id)
      rescue ActiveRecord::RecordNotFound => e
        errors = {:record_not_found => e.message}
      rescue => e
        errors = {:unknown_exception => e}
      end
      
      if gathering_user
        Response.new(:gathering_user => gathering_user)
      else
        Response.new(:gathering_user => nil, :errors => errors)
      end
    end
    
    def edit
      show
    end
    
    def list
      if request.user_id
        gathering_users = GatheringUser.where(:user_id => request.user_id).all
        gatherings = Gathering.joins(:gathering_users).where(:gathering_users => {:user_id => request.user_id}).all
      elsif request.gathering_id
        gathering_users = GatheringUser.includes(:user).where(:gathering_id => request.gathering_id).all
        users = User.joins(:gathering_users).where(:gathering_users => {:gathering_id => request.gathering_id}).all
      else
        gathering_users = GatheringUser.all
      end
      
      Response.new(:gathering_users => gathering_users, :gatherings => gatherings, :users => users)
    end
    
    def new
      gathering_user = GatheringUser.new
      Response.new(:gathering_user => gathering_user)
    end
    
    def destroy
      begin
        gathering_user = GatheringUser.find(request.id)
        
        if gathering_user.single_owner?
          # TODO: Move error messages into their own encapsulation for easy updating 
          Response.new(:gathering_user => gathering_user, :errors => {:unable_to_destroy_last_owner => "We are unable to destroy the only owner of a gathering, please make a new owner if you want to remove this one or delete the gathering directly if you no longer need it."})
        elsif gathering_user.destroy
          Response.new(:gathering_user => gathering_user)
        else
          errors.merge(gathering_user.errors)
          Response.new(:gathering_user => gathering_user, :errors => errors)
        end
        
      rescue ActiveRecord::RecordNotFound => e
        Response.new(:gathering_user => nil, :errors => {:record_not_found => e.message})
      rescue => e
        Response.new(:errors => {:unknown_exception => e})
      end
    end
    
  end
end