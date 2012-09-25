# -*- coding: UTF-8 -*-

module UseCases

  class UseCase
    include ErrorsModule

    # This works because we're in Rails, so AR automatically is visible everywhere; otherwise we'd need to require and include active_model and active_attr
    attr_accessor :request, :errors # errors is a hash in ErrorsModule that we want to be accessible to any use cases

    def initialize(request_or_hash = { })
      if request_or_hash.is_a?(Hash)
        self.request = Request.new(request_or_hash)
      else
        self.request = request_or_hash
      end
    end
    
    # helper method for responding from the use case, we always want to add any errors that were added so consolidating that here
    def respond_with(response_hash = {})
      response_hash[:errors] = errors
      Response.new(response_hash)
    end
  end

end
