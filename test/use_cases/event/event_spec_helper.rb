
module EventSpecHelper
  include UseCases
  
  def use_event(atts = {})
    atts.merge!(:ability => Ability.new(atts[:user]))
    EventUseCase.new(atts)
  end
end