require 'test_helper'

include UseCases

describe GatheringUseCase do
  describe "destroy" do
    it "successfully destroys a gathering without events" do
      gathering = Factory.create(:gathering)
      response = GatheringUseCase.new(:id => gathering.id).destroy
      response.ok?.must_equal(true)
    end
    
    it "successfully destroys a gathering with at least one event and destroys any subsequent events" do
      event = Factory.create(:event)
      gathering = event.gathering
      response = GatheringUseCase.new(:id => gathering.id).destroy
      response.ok?.must_equal(true)
      Event.where(:id => event.id).must_be_empty
    end
  end
end
