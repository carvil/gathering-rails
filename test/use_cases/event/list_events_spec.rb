require 'test_helper'

include UseCases

describe EventUseCase do
  describe "list" do    
    it "returns all Events that have been persisted and to which the current user is associated via Gatherings" do
      owner = Factory.create(:owner)
      event1 = Factory.create(:event, :gathering => owner.gathering)
      owner2 = Factory.create(:owner, :user => owner.user)
      event2 = Factory.create(:event, :gathering => owner2.gathering)
      owner3 = Factory.create(:owner)
      event3 = Factory.create(:event, :gathering => owner3.gathering)
      response = use_event(:user => owner.user).list
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
      response.events.must_include(event1)
      response.events.must_include(event2)
      response.events.wont_include(event3)
    end
  end
  
  describe "list_by_gathering" do
    before :all do
      @owner = Factory.create(:owner)
      @contributor = Factory.create(:contributor, :gathering => @owner.gathering)
      @reader = Factory.create(:contributor, :gathering => @owner.gathering)
      
      @event1 = Factory.create(:event, :gathering => @owner.gathering)
      @event2 = Factory.create(:event, :gathering => @owner.gathering)
      @event3 = Factory.create(:event)
    end

    it "returns all Events associated to a requested gathering and to which the requesting user as permission to read" do
      
      response = use_event(:gathering => @owner.gathering, :user => @owner.user).list_by_gathering
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
      response.events.must_include(@event1)
      response.events.must_include(@event2)
      response.events.wont_include(@event3)
      
      response = use_event(:gathering => @contributor.gathering, :user => @contributor.user).list_by_gathering
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
      
      response = use_event(:gathering => @reader.gathering, :user => @reader.user).list_by_gathering
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
    end
    
    it "returns all Events associated to a particular gathering if passed a gathering_id" do
      response = use_event(:gathering_id => @event1.gathering.id, :user => @owner.user).list_by_gathering
      response.ok?.must_equal(true)
      response.events.size.must_equal(2)
      response.events.must_include(@event1)
      response.events.must_include(@event2)
      response.events.wont_include(@event3)
    end
    
    it "returns the gathering that was passed in" do
      response = use_event(:gathering => @event1.gathering, :user => @owner.user).list_by_gathering
      response.ok?.must_equal(true)
      response.gathering.must_equal(@event1.gathering)
    end
  end
end
