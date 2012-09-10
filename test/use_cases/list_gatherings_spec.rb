require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "#list" do    
    it "returns all Gatherings that have been persisted" do
      gathering1 = Factory.create(:gathering)
      gathering2 = Factory.create(:gathering)
      gathering3 = Factory.build(:gathering)
      response = GatheringUseCase.new.list
      response.ok?.must_equal(true)
      response.gatherings.size.must_equal(2)
      response.gatherings.must_include(gathering1)
      response.gatherings.must_include(gathering2)
      response.gatherings.wont_include(gathering3)
    end
  end
end
