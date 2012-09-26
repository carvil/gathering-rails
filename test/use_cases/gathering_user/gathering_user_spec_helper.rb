
module GatheringUserSpecHelper
  include UseCases
  
  def use(atts = {})
    atts.merge!(:ability => Ability.new(atts[:user]))
    GatheringUserUseCase.new(atts)
  end
end