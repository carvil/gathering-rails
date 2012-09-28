
module EventSpecHelper
  include UseCases
  
  def use_event(atts = {})
    EventUseCase.new(atts)
  end
end