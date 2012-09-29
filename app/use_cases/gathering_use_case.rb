
module UseCases
  class GatheringUseCase < UseCase

    def create
      gathering = Gathering.new(request.atts)
      # By default we create a GatheringUser as owner whenever a new gathering is created
      user = request.user
      role = "owner"

      # This conditional walks through each step and if it encounters an error will add that to the error list
      if @ability.cannot? :create, gathering
        add_error(:access_denied, self_class_symbol, __method__, :gathering, access_denied_message(__method__))
      elsif gathering.save
        response = GatheringUserUseCase.new(:atts => {:gathering => gathering, :user => user, :role => role}, :user => request.user, :user => request.user).create
        if !response.ok? || !response.gathering_user.persisted?
          # If the gathering user wasn't created we MUST destroy the gathering or or it will be orphaned.  This should never happen but better safe than sorry.
          gathering.destroy
          # Add the overall error from the perspective of the gathering
          add_error(:gathering_user, self_class_symbol, __method__, :gathering_user, :message => "Unable to create a GatheringUser, the gathering was not saved.")
        end
      else
        add_class_errors_hash(gathering.class, gathering.errors.messages, self_class_symbol, __method__)
      end

      # If we didn't trigger an exception then we respond here
      respond_with(:gathering => gathering)
    end

    def update
      begin
        gathering = Gathering.find(request.id)
        gathering.update_attributes(request.atts)
        if @ability.cannot? :update, gathering
          add_error(:access_denied, self_class_symbol, :update, :gathering, :message => access_denied_message(__method__))
        elsif !gathering.save
          add_class_errors_hash(gathering.class, gathering.errors.messages, self_class_symbol, __method__)
        end

        respond_with(:gathering => gathering)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering, e.message)
        respond_with(:gathering => nil)
      end
    end

    def show
      begin
        gathering = Gathering.find(request.id)
        if @ability.cannot? :show, gathering
          add_error(:access_denied, self_class_symbol, __method__, :gathering, access_denied_message(__method__))
        end

        respond_with(:gathering => gathering)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering, e.message)
        respond_with(:gathering => nil)
      end
    end

    def edit
      begin
        gathering = Gathering.find(request.id)
        if @ability.cannot? :edit, gathering
          add_error(:access_denied, self_class_symbol, __method__, :gathering, access_denied_message(__method__))
        end

        respond_with(:gathering => gathering)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering, e.message)
        respond_with(:gathering => nil)
      end
    end

    def list
      # Pull all of the gathering instances that have the requesting user associated
      gatherings = []
      events = {}
      Gathering.with_user(request.user.id).each do |gathering|
        if @ability.can? :read, gathering
          gatherings << gathering
          events[gathering] = gathering.events
        end
      end

      respond_with(:gatherings => gatherings, :events => events)
    end

    def new
      gathering = Gathering.new
      if @ability.cannot? :create, gathering
        add_error(:access_denied, self_class_symbol, __method__, :gathering, access_denied_message(:create))
        gathering = nil
      end
      respond_with(:gathering => gathering)
    end

    def destroy
      begin
        gathering = Gathering.find(request.id)
        if @ability.cannot? :destroy, gathering
          add_error(:access_denied, self_class_symbol, __method__, :gathering, access_denied_message(__method__))
          gathering = nil
        elsif !gathering.destroy
          add_class_errors_hash(gathering.class, gathering.errors.messages, self_class_symbol, __method__)
        end
        respond_with(:gathering => gathering)
      rescue ActiveRecord::RecordNotFound => e
        add_error(:record_not_found, self_class_symbol, __method__, :gathering, "Gathering with id of #{request.id} could not be found.")
        respond_with(:gathering => nil)
      end
    end

    private
    def access_denied_message(action)
      "Requesting user does not have sufficient permission to #{action.to_s} a Gathering"
    end
  end
end
