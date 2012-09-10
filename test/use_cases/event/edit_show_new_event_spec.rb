require 'test_helper'

include UseCases

describe EventUseCase do
  describe "edit" do
    it "returns the desired event for edit" do
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id).edit
      response.ok?.must_equal(true)
      response.event.must_equal(event)
      response.event.id.must_equal(event.id)
    end
    
    it "returns errors if the event does not exist for edit" do
      response = EventUseCase.new(:id => 0).edit
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
  
  describe "show" do
    it "returns the desired event for show" do
      event = Factory.create(:event)
      response = EventUseCase.new(:id => event.id).edit
      response.ok?.must_equal(true)
      response.event.must_equal(event)
      response.event.id.must_equal(event.id)
    end
    
    it "returns errors if the event does not exist for show" do
      response = EventUseCase.new(:id => 0).edit
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
  
  describe "new" do
    it "returns an new event instance" do
      response = EventUseCase.new.new
      response.ok?.must_equal(true)
      response.event.must_be_instance_of(Event)
      response.event.persisted?.must_equal(false)
    end
  end

end

