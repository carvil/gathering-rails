# -*- coding: UTF-8 -*-

module UseCases
  class UseCase
    include ErrorsModule

    # This works because we're in Rails, so AR automatically is visible everywhere; otherwise we'd need to require and include active_model and active_attr
    attr_accessor :request, :errors

    def initialize(request_or_hash = { })
      if request_or_hash.is_a?(Hash)
        self.request = Request.new(request_or_hash)
      else
        self.request = request_or_hash
      end
      
      # Setup the CanCan abilities; TODO: Ensure that CanCan is properly loaded for UseCases
      @ability = Ability.new(self.request.user)
      
      # Setup the errors module
      initialize_errors_module
    end
    
    private
    # helper method for responding from the use case, we always want to add any errors that were added so consolidating that here
    def respond_with(response_hash = {})
      if response_hash[:errors]
        response_hash[:errors].merge!(errors)  # Just in case there are errors loaded directly from the caller, we don't want to completely obliterate them
      else
        response_hash[:errors] = errors
      end
      
      Response.new(response_hash)
    end
    
    # helper method to return a symbol representation of the current class for help with adding new errors and tracking
    def self_class_symbol
      self.class.to_s.underscore.to_sym
    end
  end
end
