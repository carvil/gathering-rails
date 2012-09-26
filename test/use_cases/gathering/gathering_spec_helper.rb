
module GatheringSpecHelper
  include UseCases
  
  def use_gathering(atts = {})
    atts.merge!(:ability => Ability.new(atts[:user]))
    GatheringUseCase.new(atts)
  end
end