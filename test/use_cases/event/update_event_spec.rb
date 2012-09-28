require 'test_helper'
require_relative 'event_spec_helper'

include EventSpecHelper

describe EventUseCase do
  describe "update" do
    before :each do
      @owner = Factory.create(:owner)
      @event = Factory.create(:event, :gathering => @owner.gathering)
    end
    
    def new_attributes(atts = {})
      {
        :title => "New Title",
        :description => "New Description",
        :location => "New Location",
        :scheduled_date => "1/1/1900 00:00",
        :cancelled_at => "1/2/1900 00:01"
      }.merge(atts)
    end
    
    it "updates a record when passed valid attributes" do
      new_atts = new_attributes
      response = use_event(:id => @event.id, :atts => new_attributes, :user => @owner.user).update
      response.ok?.must_equal(true)
      event = Event.find(response.event.id)
      event.title.must_equal(new_atts[:title])
      event.description.must_equal(new_atts[:description])
      event.location.must_equal(new_atts[:location])
      event.scheduled_date.must_equal(Time.zone.parse(new_atts[:scheduled_date]))
      event.cancelled_at.wont_be_nil
    end

    it "updates a record when the requesting user is not a reader" do
      new_atts = new_attributes
      contributor = Factory.create(:contributor, :gathering => @event.gathering)
      response = use_event(:id => @event.id, :atts => new_attributes, :user => @owner.user).update
      response.ok?.must_equal(true)
      response = use_event(:id => @event.id, :atts => new_attributes, :user => contributor.user).update
      response.ok?.must_equal(true)
    end
    
    it "returns an error when the requesting user does not have permission to update an event" do
      reader = Factory.create(:reader, :gathering => @event.gathering)
      
      response = use_event(:id => @event.id, :atts => new_attributes, :user => reader.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end

    it "returns an error when passing a blank title" do
      response = use_event(:id => @event.id, :atts => new_attributes(:title => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:event_title)
    end
    
    it "returns an error when passing a blank description" do
      response = use_event(:id => @event.id, :atts => new_attributes(:description => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:event_description)
    end
    
    it "returns an error when passing a blank location" do
      response = use_event(:id => @event.id, :atts => new_attributes(:location => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:event_location)
    end
    
    it "returns an error when passing a blank scheduled_date" do
      response = use_event(:id => @event.id, :atts => new_attributes(:scheduled_date => ""), :user => @owner.user).update
      response.ok?.must_equal(false)
      response.errors.must_include(:event_scheduled_date)
    end
    
    it "returns no error when passing a blank cancelled_at" do
      response = use_event(:id => @event.id, :atts => new_attributes(:cancelled_at => ""), :user => @owner.user).update
      response.ok?.must_equal(true)
    end
    
    it "sets the cancelled_at to current date/time if any non-zero/false/nil value is passed" do
      response = use_event(:id => @event.id, :atts => new_attributes(:cancelled_at => "asdf"), :user => @owner.user).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.wont_be_nil
      
      @event = Factory.create(:event, :gathering => @event.gathering)
      response = use_event(:id => @event.id, :atts => new_attributes(:title => "new title 1", :cancelled_at => 1), :user => @owner.user).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.wont_be_nil
      
      @event = Factory.create(:event, :gathering => @event.gathering)
      response = use_event(:id => @event.id, :atts => new_attributes(:title => "new title 2", :cancelled_at => true), :user => @owner.user).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.wont_be_nil
      
      @event = Factory.create(:event, :gathering => @event.gathering)
      response = use_event(:id => @event.id, :atts => new_attributes(:title => "new title 3", :cancelled_at => 0), :user => @owner.user).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.must_be_nil
      
      @event = Factory.create(:event, :gathering => @event.gathering)
      response = use_event(:id => @event.id, :atts => new_attributes(:title => "new title 4", :cancelled_at => nil), :user => @owner.user).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.must_be_nil
      
      @event = Factory.create(:event, :gathering => @event.gathering)
      response = use_event(:id => @event.id, :atts => new_attributes(:title => "new title 5", :cancelled_at => false), :user => @owner.user).update
      response.ok?.must_equal(true)
      response.event.cancelled_at.must_be_nil  
    end
  end
end
