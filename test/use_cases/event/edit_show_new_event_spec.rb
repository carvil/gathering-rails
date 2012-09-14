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
    
    it "returns a new event instance with a populated gathering if a valid gathering is passed as part of the request" do
      gathering = Factory.create(:gathering)
      response = EventUseCase.new(:gathering => gathering).new
      response.ok?.must_equal(true)
      response.event.gathering.must_equal(gathering)
      response = EventUseCase.new(:gathering_id => gathering.id).new
      response.ok?.must_equal(true)
      response.event.gathering.must_equal(gathering)
    end
    
    it "returns a listing of all gatherings available for association to the event" do
      gathering1 = Factory.create(:gathering)
      gathering2 = Factory.create(:gathering)
      gathering3 = Factory.build(:gathering)
      response = EventUseCase.new().new
      response.ok?.must_equal(true)
      response.gatherings.wont_be_nil
      response.gatherings.must_include(gathering1)
      response.gatherings.must_include(gathering2)
      response.gatherings.wont_include(gathering3)
    end
    
    it "returns a listing of all gatherings available for association to the event if a gathering is passed as part of the request" do
      gathering1 = Factory.create(:gathering)
      gathering2 = Factory.create(:gathering)
      gathering3 = Factory.build(:gathering)
      response = EventUseCase.new(:gathering => gathering1).new
      response.ok?.must_equal(true)
      response.gatherings.wont_be_nil
      response.gatherings.must_include(gathering1)
      response.gatherings.must_include(gathering2)
      response.gatherings.wont_include(gathering3)
    end
    
  end

end

