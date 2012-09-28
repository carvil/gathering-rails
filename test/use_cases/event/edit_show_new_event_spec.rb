require 'test_helper'
require_relative 'event_spec_helper'

include EventSpecHelper

describe EventUseCase do
  describe "edit" do
    before :each do
      @owner = Factory.create(:owner)
      @event = Factory.create(:event, :gathering => @owner.gathering)
    end
    
    it "returns the desired event for edit if the requesting user has permission" do
      response = use_event(:id => @event.id, :user => @owner.user).edit
      
      response.ok?.must_equal(true)
      response.event.must_equal(@event)
      response.event.id.must_equal(@event.id)
    end
    
    it "returns errors if the event does not exist for edit" do
      response = use_event(:id => 0, :user => @owner.user).edit
      
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if the requesting user does not have permission to edit the event" do
      reader = Factory.create(:reader, :gathering => @event.gathering)
      
      response = use_event(:id => @event.id, :user => reader.user).edit
      
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
  
  describe "show" do
    before :each do
      @owner = Factory.create(:owner)
      @event = Factory.create(:event, :gathering => @owner.gathering)
    end
    
    it "returns the desired event for show if the requesting user has permission" do
      response = use_event(:id => @event.id, :user => @owner.user).show
      
      response.ok?.must_equal(true)
      response.event.must_equal(@event)
      response.event.id.must_equal(@event.id)
    end
    
    it "returns errors if the event does not exist for show" do
      response = use_event(:id => 0, :user => @owner.user).show
      
      response.ok?.must_equal(false)
      response.errors.must_include(:record_not_found)
    end
    
    it "returns an error if the requesting user does not have permission to read the event" do
      # This is a user that owns a different gathering, so they shouldn't be able to access @event
      owner = Factory.create(:owner)
      
      response = use_event(:id => @event.id, :user => owner.user).show
      
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
  
  describe "new" do
    before :each do
      @owner = Factory.create(:owner)
    end

    it "returns a new event instance if the requesting user has permission to create new events for the gathering" do
      response = use_event(:user => @owner.user).new
      response.ok?.must_equal(true)
      response.event.must_be_instance_of(Event)
      response.event.persisted?.must_equal(false)
    end
    
    it "returns a new event instance with a populated gathering if a valid gathering is passed as part of the request" do
      response = use_event(:gathering => @owner.gathering, :user => @owner.user).new
      response.ok?.must_equal(true)
      response.event.gathering.must_equal(@owner.gathering)
      response = use_event(:gathering_id => @owner.gathering.id, :user => @owner.user).new
      response.ok?.must_equal(true)
      response.event.gathering.must_equal(@owner.gathering)
    end
    
    it "returns a listing of all gatherings available for association to the event" do
      gathering1 = Factory.create(:owner, :user => @owner.user).gathering
      gathering2 = Factory.create(:contributor, :user => @owner.user).gathering
      gathering3 = Factory.create(:reader, :user => @owner.user).gathering
      gathering4 = Factory.create(:owner).gathering
      response = use_event(:user => @owner.user).new
      response.ok?.must_equal(true)
      response.gatherings.wont_be_nil
      response.gatherings.must_include(gathering1)
      response.gatherings.must_include(gathering2)
      response.gatherings.must_include(gathering3)
      response.gatherings.wont_include(gathering4)
    end
    
    it "returns a listing of all gatherings available for association to the event if a gathering is passed as part of the request" do
      gathering1 = Factory.create(:owner, :user => @owner.user).gathering
      gathering2 = Factory.create(:contributor, :user => @owner.user).gathering
      gathering3 = Factory.create(:owner).gathering
      response = use_event(:gathering => gathering1, :user => @owner.user).new
      response.ok?.must_equal(true)
      response.gatherings.wont_be_nil
      response.gatherings.must_include(gathering1)
      response.gatherings.must_include(gathering2)
      response.gatherings.wont_include(gathering3)
    end
    
  end

end

