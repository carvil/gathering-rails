
module GatheringUserSpecHelper
  include UseCases
  
  def use_gathering_user(atts = {})
    atts.merge!(:ability => Ability.new(atts[:user]))
    GatheringUserUseCase.new(atts)
  end
end