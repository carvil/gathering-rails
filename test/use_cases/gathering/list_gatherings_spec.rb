require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "list" do    
    it "returns all Gatherings that have been persisted associated to the requesting user" do
      user = Factory.create(:user)
      gathering1 = Factory.create(:owner, :user => user).gathering
      gathering2 = Factory.create(:contributor, :user => user).gathering
      gathering3 = Factory.create(:reader, :user => user).gathering
      gathering4 = Factory.build(:owner, :user => user).gathering
      response = use_gathering(:user => user).list
      response.ok?.must_equal(true)
      response.gatherings.size.must_equal(3)
      response.gatherings.must_include(gathering1)
      response.gatherings.must_include(gathering2)
      response.gatherings.must_include(gathering3)
      response.gatherings.wont_include(gathering4)
    end
  end
end
