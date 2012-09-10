require 'test_helper'

include UseCases

describe EventUseCase do
  describe "list" do    
    it "returns all Events that have been persisted" do
      event1 = Factory.create(:event)
      event2 = Factory.create(:event)
      event3 = Factory.build(:event)
      response = EventUseCase.new.list
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
      response.events.must_include(event1)
      response.events.must_include(event2)
      response.events.wont_include(event3)
    end
  end
  
  describe "list_by_gathering" do
    it "returns all Events associated to a particular gathering" do
      event1 = Factory.create(:event)
      event2 = Factory.create(:event)
      event2.gathering = event1.gathering
      event2.save
      event3 = Factory.create(:event)
      response = EventUseCase.new(:gathering => event1.gathering).list_by_gathering
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
      response.events.must_include(event1)
      response.events.must_include(event2)
      response.events.wont_include(event3)
    end
  end
end
