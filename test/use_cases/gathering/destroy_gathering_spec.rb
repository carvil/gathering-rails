require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "destroy" do
    it "successfully destroys a Gathering without Events and destroys any Gathering Users as well" do
      gathering = Factory.create(:gathering)
      response = GatheringUseCase.new(:id => gathering.id).destroy
      response.ok?.must_equal(true)
      GatheringUser.where(:gathering_id => gathering.id).must_be_empty
    end
    
    it "successfully destroys a Gathering with at least one Event and destroys any subsequent Events" do
      event = Factory.create(:event)
      gathering = event.gathering
      response = GatheringUseCase.new(:id => gathering.id).destroy
      response.ok?.must_equal(true)
      Event.where(:id => event.id).must_be_empty
    end
  end
end
