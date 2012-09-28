
module GatheringSpecHelper
  include UseCases
  
  def use_gathering(atts = {})
    GatheringUseCase.new(atts)
  end
end