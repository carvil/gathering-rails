
module GatheringUserSpecHelper
  include UseCases
  
  def use_gathering_user(atts = {})
    GatheringUserUseCase.new(atts)
  end
end