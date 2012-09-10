require 'test_helper'

include UseCases

describe EventUseCase do
  describe "destroy" do
    it "successfully destroys an event" do
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id).destroy
      response.ok?.must_equal(true)
    end
  end
end
