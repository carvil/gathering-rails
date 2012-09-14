require 'test_helper'

include UseCases

describe EventUseCase do
  describe "create" do    
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
      atts = valid_attributes
      response = EventUseCase.new(:atts => atts).create
      
      response.ok?.must_equal(true)
      event = response.event
      event.id.wont_be_nil
      event.title.must_equal(atts[:title])
      event.description.must_equal(atts[:description])
      event.location.must_equal(atts[:location])
      event.scheduled_date.must_equal(Time.zone.parse(atts[:scheduled_date]))
      event.gathering.must_equal(atts[:gathering])
      
    end
    
    it "returns errors if the create Event request is not valid" do
      response = EventUseCase.new(:atts => valid_attributes.merge(:title => "")).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:description => "")).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:location => "")).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:scheduled_date => "")).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:gathering => nil)).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
      response = EventUseCase.new(:atts => valid_attributes.merge(:cancelled_at => "")).create
      response.ok?.must_equal(true)
      response.errors.must_be_nil
    end
    
    it "returns errors if creating an event with a duplicate title and the same gathering" do
      event_orig = EventUseCase.new(:atts => valid_attributes).create.event
      response = EventUseCase.new(:atts => valid_attributes.merge(:title => event_orig.title, :gathering => event_orig.gathering)).create
      response.ok?.must_equal(false)
      response.errors.wont_be_nil
    end
  end
end
