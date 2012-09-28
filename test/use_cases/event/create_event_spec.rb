require 'test_helper'
require_relative 'event_spec_helper'

include EventSpecHelper

describe EventUseCase do
  describe "create" do 
    
    before :each do
      @atts = valid_attributes
      @owner = Factory.create(:owner, :gathering => @atts[:gathering])
    end
    
    def valid_attributes
      {
        :title => "Main Ceremony",
        :description => "The main ceremony which will contain all the fun stuff",
        :location => "Special venue, Anywhere, USA",
        :scheduled_date => "6/1/2013 17:00",
        :gathering => Factory.create(:gathering)
      }
    end
  
    it "successfully creates and persists a new Event" do
      response = use_event(:atts => @atts, :user => @owner.user).create
      
      response.ok?.must_equal(true)
      event = response.event
      event.id.wont_be_nil
      event.title.must_equal(@atts[:title])
      event.description.must_equal(@atts[:description])
      event.location.must_equal(@atts[:location])
      event.scheduled_date.must_equal(Time.zone.parse(@atts[:scheduled_date]))
      event.gathering.must_equal(@atts[:gathering])
    end
    
    it "successfully creates and persists a new Event with a contributor user role" do
      contributor = Factory.create(:contributor, :gathering => @owner.gathering)
      
      response = use_event(:atts => @atts, :user => contributor.user).create
      
      response.ok?.must_equal(true)
      response.errors.must_be_empty
    end
    
    it "returns errors if the create Event request is not valid" do
      response = use_event(:atts => @atts.merge(:title => ""), :user => @owner.user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:event_title)
      response = use_event(:atts => @atts.merge(:description => ""), :user => @owner.user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:event_description)
      response = use_event(:atts => @atts.merge(:location => ""), :user => @owner.user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:event_location)
      response = use_event(:atts => @atts.merge(:scheduled_date => ""), :user => @owner.user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:event_scheduled_date)
      response = use_event(:atts => @atts.merge(:gathering => nil), :user => @owner.user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = use_event(:atts => @atts.merge(:cancelled_at => ""), :user => @owner.user).create
      response.ok?.must_equal(true)
      response.errors.must_be_empty
    end
    
    it "returns errors if creating an event with a duplicate title and the same gathering" do
      event_orig = use_event(:atts => @atts, :user => @owner.user).create.event
      
      response = use_event(:atts => @atts.merge(:title => event_orig.title, :gathering => event_orig.gathering), :user => @owner.user).create
      
      response.ok?.must_equal(false)
      response.errors.must_include(:event_title)
    end
    
    it "returns an error if the requesting user does not have permission to create an event" do
      reader = Factory.create(:reader, :gathering => @owner.gathering)
      
      response = use_event(:atts => @atts, :user => reader.user).create
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
      response = use_event(:atts => @atts, :user => User.new).create
      response.ok?.must_equal(false)
      response.errors.must_include(:access_denied)
    end
  end
end
